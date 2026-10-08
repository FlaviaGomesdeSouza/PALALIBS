// Ilustrações do modelo carregado por baixo
include <../x1c_mola_carga_inferior_2x13mm.scad>
peca = "nada";
vista = "explodida"; // [explodida, corte, impressao]
if (vista == "explodida") {
    color("#5b8ec9") corpo();
    for (c = centros()) translate([c[0], c[1], 0]) {
        translate([0, 0, -6]) color("#8a8a8a") cylinder(d = diametro_pastilha, h = 2.5);
        translate([0, 0, -12]) color("#f0a030") pistao_c();
        translate([0, 0, -22]) color("silver") mola_c(7);
    }
    translate([0, 0, -26]) color("#7cc47c") placa_molas();
    translate([0, 0, -34]) rotate([0, 0, -giro]) color("#e8a33d") fundo();
}
if (vista == "corte") intersection() {
    union() {
        corpo();
        translate([0, 0, -descida]) fundo();
        for (i = [0 : 1]) let(c = centros()[i], e = [3.5, 1.5][i], zf = h_corpo - t_borda) translate([c[0], c[1], 0]) {
            translate([0, 0, zf - e]) cylinder(d = diametro_pastilha - 0.1, h = e - 0.01);
            translate([0, 0, zf - e - t_pistao]) pistao_c();
            translate([0, 0, -descida]) mola_c(zf - e - t_pistao + descida);
        }
    }
    translate([-100, -50, -50]) cube([100.01, 100, 100]);
}
if (vista == "impressao") {
    translate([-34, 0, 0]) translate([0, 0, h_corpo]) mirror([0, 0, 1]) corpo();
    translate([0, 0, t_fundo]) fundo();
    translate([0, 34, t_placa_molas]) placa_molas();
    for (x = [26, 42]) translate([x, 0, t_pistao]) mirror([0, 0, 1]) pistao_c();
}
