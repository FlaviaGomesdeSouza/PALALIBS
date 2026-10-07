// Vista explodida do modelo com baioneta (só ilustração)
include <../x1c_mola_baioneta_2x13mm.scad>
peca = "nada";
color("#5b8ec9") base_baioneta();
for (c = centros()) translate([c[0], c[1], 0]) {
    translate([0, 0, z_fundo_cavidade + 9]) color("#e8a33d") pistao();
    translate([0, 0, z_fundo_cavidade + 12]) color("#8a8a8a") cylinder(d = diametro_pastilha, h = 2.5);
    translate([0, 0, espessura_fundo + 1]) color("silver") mola_ilustrativa(6);
}
translate([0, 0, z_topo + 14]) color("#d9d9d9") tampa_baioneta();
translate([0, 0, z_topo + 22]) rotate([0, 0, -giro]) color("#f06292") anel();
