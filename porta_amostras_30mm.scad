// Porta-amostras com seção de 30 mm para pastilhas prensadas de 13 mm
// (LA-ICP-MS / LIBS), sem embutimento em resina e sem polimento.
//
// Cada cavidade recebe um pistão (disco solto) sobre o qual a pastilha
// apoia. Um parafuso M3 por baixo empurra o pistão e deixa a face da
// pastilha no mesmo plano do topo do porta-amostras.
//
// Renderize "peca" = "suporte" ou "pistao" (Customizer do OpenSCAD ou -D).

/* [Peça] */
peca = "suporte"; // [suporte, pistao, conjunto]

/* [Seção do porta-amostras] */
// Diâmetro nominal da seção aceita pelo porta-amostras do equipamento (mm)
diametro_secao = 30;
// Folga diametral para entrar no porta-amostras (mm)
folga_secao = 0.1;
// Altura total do suporte (mm); ajuste à altura que o equipamento aceita
altura = 10;

/* [Pastilhas] */
// Número de pastilhas (1, 2 ou 3)
n_pastilhas = 3; // [1, 2, 3]
// Diâmetro das pastilhas (mm)
diametro_pastilha = 13;
// Folga diametral da cavidade (mm); 0.05–0.15 para usinagem, 0.15–0.25 para impressão 3D
folga_pastilha = 0.1;
// Parede mínima entre cavidades vizinhas (mm)
parede_entre = 0.6;

/* [Fundo e parafuso de nivelamento] */
// Espessura do fundo, onde fica a rosca M3 (mm)
espessura_fundo = 3;
// Furo do fundo: 2.5 para abrir rosca M3 com macho; 3.2 para M3 passante com porca/inserto
furo_parafuso = 2.5;
// Espessura do pistão (mm)
espessura_pistao = 2;
// Folga diametral entre pistão e cavidade (mm)
folga_pistao = 0.2;

/* [Acabamento] */
chanfro = 0.3;
$fn = 128;

d_secao = diametro_secao - folga_secao;
d_cavidade = diametro_pastilha + folga_pastilha;
d_pistao = d_cavidade - folga_pistao;
prof_cavidade = altura - espessura_fundo;

// Três cavidades em triângulo: entre centros = d_cavidade + parede_entre
r_centros = n_pastilhas == 1 ? 0
          : n_pastilhas == 2 ? (d_cavidade + parede_entre) / 2
          : (d_cavidade + parede_entre) / sqrt(3);
parede_externa = d_secao / 2 - r_centros - d_cavidade / 2;

echo(str("Parede externa mínima: ", parede_externa, " mm"));
echo(str("Profundidade da cavidade: ", prof_cavidade, " mm"));
assert(parede_externa > 0.3, "Parede externa < 0,3 mm: reduza parede_entre ou n_pastilhas");
assert(prof_cavidade > espessura_pistao, "Cavidade rasa demais para o pistão");

function centros() = [for (i = [0 : n_pastilhas - 1])
    let(a = 90 + i * 360 / n_pastilhas) [r_centros * cos(a), r_centros * sin(a)]];

module suporte() {
    difference() {
        // Cilindro com chanfro nas duas bordas
        hull() {
            translate([0, 0, chanfro]) cylinder(d = d_secao, h = altura - 2 * chanfro);
            cylinder(d = d_secao - 2 * chanfro, h = altura);
        }
        for (c = centros()) translate([c[0], c[1], 0]) {
            translate([0, 0, espessura_fundo]) cylinder(d = d_cavidade, h = altura);
            translate([0, 0, -1]) cylinder(d = furo_parafuso, h = altura);
        }
        // Numeração das cavidades gravada no fundo (lida de baixo)
        for (i = [0 : n_pastilhas - 1]) {
            p = centros()[i] + [3.5, 0];
            translate([p[0], p[1], -0.01]) linear_extrude(0.4)
                mirror([1, 0, 0]) text(str(i + 1), size = 2.5, halign = "center", valign = "center");
        }
    }
}

module pistao() {
    cylinder(d = d_pistao, h = espessura_pistao);
}

if (peca == "suporte") suporte();
else if (peca == "pistao") pistao();
else {
    suporte();
    for (c = centros()) translate([c[0], c[1], espessura_fundo + 1]) color("orange") pistao();
}
