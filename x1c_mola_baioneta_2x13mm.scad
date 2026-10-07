// Porta-amostras de 30 mm para 2 pastilhas de 13 mm, ajuste por mola e
// fechamento por BAIONETA: tudo impresso, só as 2 molas são compradas.
//
// Princípio do pote de conserva (tampa + anel):
//   • tampa  – disco plano com as janelas. Desce reto sobre as pastilhas e
//              NÃO gira: 2 pinos da base a travam. Assim nada raspa a face
//              das pastilhas.
//   • anel   – aro fino por cima da tampa, com 2 garras. É a única peça que
//              gira: encaixe as garras nos rasgos da base, empurre e gire
//              ~35° no sentido anti-horário (visto de cima) até o "clique".
//   • A mola empurra tudo para cima e assenta os dentes das garras num
//     rebaixo (trava): para abrir, empurre e gire de volta.
//
// Peças: "base", "tampa", "anel", "pistao", "conjunto".

include <x1c_mola_2x13mm.scad>

/* [Peça] */
peca = "conjunto"; // [base, tampa, anel, pistao, conjunto]
material = "PC"; // [PC, PETG]

/* [Baioneta] */
// Espessura da tampa plana e do aro do anel (mm)
t_placa = 1.6;
t_aro = 1.2;
// Altura total montada: base + tampa + aro. Confira o máximo do porta-amostras
altura = 14;
// Raio interno do aro do anel (não pode cobrir a área útil das janelas)
r_aro_int = 13.0;
// Garras: espessura radial, largura angular, dente (profundidade radial e altura)
t_garra = 1.2;
largura_garra = 26;
dente = 0.8;
h_dente = 1.2;
// Espessura do ressalto da base sobre o dente e giro de travamento (graus)
h_ressalto = 1.5;
giro = 35;
// Rebaixo de trava (o dente sobe nele com a força da mola)
h_trava = 0.6;
// Folga radial/vertical das peças móveis (mm)
folga_b = 0.25;
// Pinos-guia da tampa (na base) e furos correspondentes na tampa
r_pinos = 10.5;
d_pino = 2.0;
h_pino = 1.5;

renderizar_principal = false;

// A base usa o espaço da tampa antiga para tampa + aro
// (valor fixo: no OpenSCAD esta atribuição sobe para a posição do arquivo
// principal, antes de t_placa e t_aro existirem)
espessura_tampa = 2.8;
furo_tampa_base = 0;          // sem parafusos

R = d_secao / 2;
r_garra_int = R - t_garra;
r_dente_int = r_garra_int - dente;
L_garra = t_placa + h_ressalto + h_dente + 0.15;  // do aro para baixo
z_topo = altura_base;
z_ressalto = z_topo - h_ressalto;                  // face de baixo do ressalto
z_dente_base = z_ressalto - 0.15 - h_dente;        // dente com o anel apertado
z_canal = z_dente_base - 0.2;
angulos_entrada = [0, 180];

echo(str("Baioneta: garras de ", L_garra, " mm; tampa sobe ", 0.15 + h_trava,
         " mm ao travar; altura total ", altura, " mm"));
assert(espessura_tampa == t_placa + t_aro, "espessura_tampa deve ser t_placa + t_aro");
assert(r_dente_int - folga_b > r_pinos + d_pino, "Canal da baioneta encosta nos pinos");

module setor(r0, r1, a0, a1, z0, z1) {
    // Setor anular entre os raios r0–r1, ângulos a0–a1 (graus) e alturas z0–z1
    translate([0, 0, z0]) linear_extrude(z1 - z0) intersection() {
        difference() { circle(r = r1); circle(r = r0); }
        polygon([[0, 0], for (a = [a0 : (a1 - a0) / 24 : a1]) 3 * r1 * [cos(a), sin(a)]]);
    }
}

module base_baioneta() {
    meia = largura_garra / 2;
    difference() {
        base();
        for (a0 = angulos_entrada) {
            // Folga do caminho das garras (por fora do pescoço)
            setor(r_garra_int - folga_b, R + 1, a0 - meia - 2, a0 + giro + meia + 2, z_canal, z_topo + 1);
            // Rasgo de entrada: o dente desce até o canal
            setor(r_dente_int - folga_b, R + 1, a0 - meia - 1, a0 + meia + 1, z_canal, z_topo + 1);
            // Canal horizontal: o dente gira por baixo do ressalto
            setor(r_dente_int - folga_b, R + 1, a0 - meia - 1, a0 + giro + meia + 1, z_canal, z_ressalto);
            // Rebaixo de trava na posição fechada
            setor(r_dente_int - folga_b, R + 1, a0 + giro - meia - 0.5, a0 + giro + meia + 1, z_ressalto - 0.01, z_ressalto + h_trava);
        }
    }
    // Pinos que impedem a tampa de girar
    for (a = angulos_entrada) translate([r_pinos * cos(a), r_pinos * sin(a), z_topo - 0.01])
        cylinder(d = d_pino, h = h_pino, $fn = 32);
}

module tampa_baioneta() {
    meia = largura_garra / 2;
    d_topo = min(d_janela + 2 * (t_placa - aba_reta), dist_centros - 0.6);
    difference() {
        cilindro_chanfrado(d_secao, t_placa);
        for (c = centros()) translate([c[0], c[1], -0.01]) {
            cylinder(d = d_janela, h = aba_reta + 0.02);
            translate([0, 0, aba_reta]) cylinder(d1 = d_janela, d2 = d_topo, h = t_placa - aba_reta + 0.03);
        }
        // Recortes por onde passam as garras
        for (a0 = angulos_entrada)
            setor(r_garra_int - folga_b, R + 1, a0 - meia - 2, a0 + giro + meia + 2, -1, t_placa + 1);
        // Furos dos pinos-guia
        for (a = angulos_entrada) translate([r_pinos * cos(a), r_pinos * sin(a), -1])
            cylinder(d = d_pino + 0.3, h = t_placa + 2, $fn = 32);
    }
}

// Anel na posição fechada (garras em a0 + giro)
module anel() {
    meia = largura_garra / 2;
    // Aro
    translate([0, 0, t_placa]) difference() {
        cilindro_chanfrado(d_secao, t_aro);
        translate([0, 0, -1]) cylinder(r = r_aro_int, h = t_aro + 2);
        // Marcas de posição sobre cada garra
        for (a0 = angulos_entrada) rotate([0, 0, a0 + giro])
            translate([R - 0.9, 0, t_aro - 0.4]) cylinder(d = 0.9, h = 1, $fn = 16);
    }
    for (a0 = angulos_entrada) {
        a = a0 + giro;
        // Garra
        setor(r_garra_int, R, a - meia, a + meia, t_placa - L_garra, t_placa + 0.01);
        // Dente para dentro, na ponta da garra
        setor(r_dente_int, r_garra_int + 0.01, a - meia, a + meia, t_placa - L_garra, t_placa - L_garra + h_dente);
    }
}

if (peca == "base") base_baioneta();
else if (peca == "tampa") tampa_baioneta();
else if (peca == "anel") anel();
else if (peca == "pistao") pistao();
else if (peca == "conjunto") {
    color("#5b8ec9") base_baioneta();
    translate([0, 0, z_topo + 0.15 + h_trava]) {
        color("#d9d9d9") tampa_baioneta();
        color("#e8a33d") anel();
    }
}
