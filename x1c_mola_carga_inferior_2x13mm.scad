// Porta-amostras de 30 mm para 2 pastilhas de 13 mm, carregado POR BAIXO.
// Tudo impresso; só as 2 molas são compradas.
//
//   • corpo  – cilindro com 2 furos passantes. No topo, uma borda fina
//              (0,6 mm) segura a pastilha pela beirada: é a única coisa
//              acima da face de análise. As duas bordas são impressas
//              direto na mesa, então ficam planas e no mesmo plano.
//   • pistão – disco com pino-guia: encaixe de cima da mola.
//   • placa  – placa de molas com 2 pinos-guia (encaixe de baixo da mola).
//              Não gira: 2 pinos entram em furos no corpo. Assim a mola fica
//              presa nas duas pontas e nada a arrasta.
//   • fundo  – tampa de baixo com 2 garras de baioneta. Gira ~35° por baixo
//              da placa para travar; as molas empurram placa e fundo para
//              baixo e assentam os dentes num rebaixo (trava).
//
// Montagem: corpo de cabeça para baixo → pastilhas com a face para baixo →
// pistões (pino para cima) → molas → placa (pinos nos furos) → fundo: encaixe,
// empurre e gire ~35° no sentido horário (olhando para o fundo) → vire.
//
// Peças: "corpo", "placa", "fundo", "pistao", "conjunto".

include <x1c_fdm.scad>

/* [Peça] */
peca = "conjunto"; // [corpo, placa, fundo, pistao, conjunto]
material = "PC"; // [PC, PETG]
renderizar_principal = false;
n_pastilhas = 2;

/* [Medidas gerais] */
// Altura total montada (corpo + placa + fundo). Confira o máximo do porta-amostras
altura_total = 12;
// Espessura do fundo (tampa de baixo) e da placa de molas
t_fundo = 1.2;
t_placa_molas = 1.0;
// A placa fica dentro do círculo dos dentes da baioneta
r_placa_molas = 12.6;
// Pinos-guia da mola na placa e pinos que travam a placa no corpo
h_guia_placa = 1.2;
r_trava_placa = 10;
d_trava_placa = 2.0;
h_trava_placa = 1.5;

/* [Borda que segura a pastilha] */
// Espessura da borda acima da face de análise (mm)
t_borda = 0.6;
// Quanto a borda cobre a beirada da pastilha, no raio (mm)
aba_borda = 0.8;
// Parte reta da borda antes do chanfro (mm)
borda_reta = 0.3;

/* [Pastilha, pistão e mola] */
esp_min = 1;
esp_max = 4;
t_pistao = 2;
d_pino = 4.0;
h_pino = 1.5;
// Mola de compressão inox, leve: Ø ext. 6, livre 10, sólida <= 3 (fio 0,3 mm)
d_mola_ext = 6;
mola_livre = 10;
mola_solida = 3;

/* [Baioneta do fundo] */
t_garra = 1.2;
largura_garra = 26;
dente = 0.6;
h_dente = 1.2;
h_ressalto = 1.5;
giro = 35;
h_trava = 0.4;
folga_b = 0.25;
angulos_entrada = [0, 180];

R = d_secao / 2;
h_corpo = altura_total - t_fundo - t_placa_molas;
r_garra_int = R - t_garra;
r_dente_int = r_garra_int - dente;
L_garra = t_placa_molas + h_ressalto + 0.15 + h_dente;   // do topo do fundo
z_canal_topo = h_ressalto + 0.15 + h_dente + 0.2;   // no referencial do corpo
d_janela_b = diametro_pastilha - 2 * aba_borda;
d_janela_b_topo = d_janela_b + 2 * (t_borda - borda_reta);
descida = 0.15 + h_trava;                            // fundo desce ao travar

// Mola: comprimento com a pastilha mais grossa / mais fina (fundo travado)
mola_curta = h_corpo - t_borda - esp_max - t_pistao + descida;
mola_longa = mola_curta + esp_max - esp_min;
echo(str("Mola entre ", mola_curta, " e ", mola_longa, " mm (livre ", mola_livre, ", sólida ", mola_solida, ")"));
echo(str("Acima da face de análise: só a borda de ", t_borda, " mm; altura total ", altura_total + descida, " mm travado"));
assert(mola_curta >= mola_solida + 0.3, "Mola chega ao comprimento sólido: aumente altura_total ou reduza esp_max");
assert(mola_longa <= mola_livre - 1, "Mola sem pré-carga com a pastilha fina: use mola mais longa");
assert(h_pino + h_guia_placa < mola_curta - 0.5, "Pinos-guia (pistão + placa) se tocam dentro da mola");
assert(r_placa_molas < r_dente_int - folga_b - 0.2, "Placa de molas encosta nos dentes da baioneta");

module setor(r0, r1, a0, a1, z0, z1) {
    translate([0, 0, z0]) linear_extrude(z1 - z0) intersection() {
        difference() { circle(r = r1); circle(r = r0); }
        polygon([[0, 0], for (a = [a0 : (a1 - a0) / 24 : a1]) 3 * r1 * [cos(a), sin(a)]]);
    }
}

// Corpo na posição de uso (z = 0 é a face de baixo do corpo)
module corpo() {
    meia = largura_garra / 2;
    difference() {
        cilindro_chanfrado(d_secao, h_corpo);
        for (i = [0 : n_pastilhas - 1]) {
            c = centros()[i];
            translate([c[0], c[1], 0]) {
                // Furo passante até a borda
                translate([0, 0, -1]) cylinder(d = d_cavidade, h = h_corpo - t_borda + 1);
                // Janela da borda, com chanfro para fora
                translate([0, 0, h_corpo - t_borda - 0.01]) cylinder(d = d_janela_b, h = borda_reta + 0.02);
                translate([0, 0, h_corpo - t_borda + borda_reta])
                    cylinder(d1 = d_janela_b, d2 = d_janela_b_topo, h = t_borda - borda_reta + 0.01);
            }
            // Número gravado no topo, ao lado da janela
            translate([c[0] + 8.4, c[1], h_corpo - 0.3]) linear_extrude(1)
                text(str(i + 1), size = 2.5, halign = "center", valign = "center");
        }
        for (a0 = angulos_entrada) {
            setor(r_garra_int - folga_b, R + 1, a0 - meia - 2, a0 + giro + meia + 2, -1, z_canal_topo);
            setor(r_dente_int - folga_b, R + 1, a0 - meia - 1, a0 + meia + 1, -1, z_canal_topo);
            setor(r_dente_int - folga_b, R + 1, a0 - meia - 1, a0 + giro + meia + 1, h_ressalto, z_canal_topo);
            setor(r_dente_int - folga_b, R + 1, a0 + giro - meia - 0.5, a0 + giro + meia + 1,
                  h_ressalto - h_trava, h_ressalto + 0.01);
            // Furo do pino que trava a placa de molas
            translate([r_trava_placa * cos(a0), r_trava_placa * sin(a0), -1])
                cylinder(d = d_trava_placa + 0.4, h = h_trava_placa + 1.3, $fn = 32);
        }
    }
}

// Fundo na posição travada; z = 0 é a face de cima do fundo
module fundo() {
    meia = largura_garra / 2;
    difference() {
        translate([0, 0, -t_fundo]) cilindro_chanfrado(d_secao, t_fundo);
        // Marcas gravadas na lateral, alinhadas com as garras
        for (a0 = angulos_entrada) rotate([0, 0, a0 + giro])
            translate([R - 0.4, 0, -t_fundo / 2]) rotate([0, 90, 0]) cylinder(d = 0.9, h = 1, $fn = 16);
    }
    for (a0 = angulos_entrada) {
        a = a0 + giro;
        setor(r_garra_int, R, a - meia, a + meia, -0.01, L_garra);
        setor(r_dente_int, r_garra_int + 0.01, a - meia, a + meia, L_garra - h_dente, L_garra);
    }
}

// Placa de molas na posição de uso; z = 0 é a face de cima da placa
module placa_molas() {
    translate([0, 0, -t_placa_molas]) cylinder(r = r_placa_molas, h = t_placa_molas);
    for (c = centros()) translate([c[0], c[1], -0.01]) cylinder(d = d_pino, h = h_guia_placa + 0.01);
    for (a0 = angulos_entrada) translate([r_trava_placa * cos(a0), r_trava_placa * sin(a0), -0.01])
        cylinder(d = d_trava_placa, h = h_trava_placa + 0.01, $fn = 32);
}

module pistao_c() {
    cylinder(d = d_pistao, h = t_pistao);
    translate([0, 0, -h_pino]) cylinder(d = d_pino, h = h_pino + 0.01);
}

module mola_c(L) {
    n = 7;
    for (i = [0 : n - 1]) translate([0, 0, i * L / n]) rotate_extrude($fn = 32)
        translate([d_mola_ext / 2 - 0.15, L / n / 2]) circle(d = 0.3, $fn = 8);
}

// Peças exportadas já na orientação de impressão
if (peca == "corpo") translate([0, 0, h_corpo]) mirror([0, 0, 1]) corpo();   // topo na mesa
else if (peca == "placa") translate([0, 0, t_placa_molas]) placa_molas();   // face de baixo na mesa, pinos para cima
else if (peca == "fundo") translate([0, 0, t_fundo]) fundo();                // base na mesa, garras para cima
else if (peca == "pistao") translate([0, 0, t_pistao]) mirror([0, 0, 1]) pistao_c(); // face plana na mesa
else if (peca == "conjunto") {
    esp = [3.5, 1.5];
    color("#5b8ec9") corpo();
    translate([0, 0, -descida]) color("#7cc47c") placa_molas();
    translate([0, 0, -descida - t_placa_molas]) color("#e8a33d") fundo();
    for (i = [0 : n_pastilhas - 1]) let(c = centros()[i], zf = h_corpo - t_borda) translate([c[0], c[1], 0]) {
        translate([0, 0, zf - esp[i]]) color("#8a8a8a") cylinder(d = diametro_pastilha, h = esp[i]);
        translate([0, 0, zf - esp[i] - t_pistao]) color("#f0a030") pistao_c();
        translate([0, 0, -descida]) color("silver") mola_c(zf - esp[i] - t_pistao + descida);
    }
}
