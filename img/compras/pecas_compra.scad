// Ilustrações das peças compradas (medidas nominais), só para referência visual.
peca = "inserto"; // [inserto, grub, escareado]
$fn = 64;

module rosca(d, L, passo = 0.5) {
    // Filetes em dente de serra (visual), sem hélice
    h = 0.3;
    n = floor(L / passo);
    rotate_extrude() polygon(concat([[0, 0]],
        [for (i = [0 : n - 1], k = [0, 1]) [k == 0 ? d / 2 - h : d / 2, i * passo + k * passo / 2]],
        [[d / 2 - h, n * passo], [d / 2 - h, L], [0, L]]));
}

module inserto() {   // inserto de latão M3 × 4 × Ø5 (serrilhado)
    difference() {
        union() {
            for (z = [0, 2.1]) translate([0, 0, z]) intersection() {
                cylinder(d = 5, h = 1.9);
                union() for (a = [0 : 20 : 340], s = [-1, 1]) rotate([0, 0, a])
                    linear_extrude(1.9, twist = 40 * s) translate([2.1, 0]) square([0.6, 0.6], center = true);
            }
            cylinder(d = 4.3, h = 4);
        }
        translate([0, 0, -1]) cylinder(d = 2.6, h = 6);
        translate([0, 0, 3.6]) cylinder(d1 = 2.6, d2 = 3.2, h = 0.41);
    }
}

module grub() {      // DIN 913 M3 × 10, sextavado interno 1,5 mm, ponta plana chanfrada
    difference() {
        intersection() {
            rosca(3, 10);
            union() {
                cylinder(d1 = 2.2, d2 = 3.2, h = 0.5);
                translate([0, 0, 0.5]) cylinder(d = 3.2, h = 9);
                translate([0, 0, 9.5]) cylinder(d1 = 3.2, d2 = 2.2, h = 0.5);
            }
        }
        translate([0, 0, 8]) cylinder(d = 1.5 / cos(30), h = 3, $fn = 6);
    }
}

module escareado() { // DIN 965 M3 × 10, cabeça chata Ø6 × 1,65, fenda Phillips
    difference() {
        union() {
            translate([0, 0, 10 - 1.65]) cylinder(d1 = 3, d2 = 6, h = 1.65);
            intersection() { rosca(3, 10 - 1.65 + 0.01); cylinder(d = 3.2, h = 10); }
        }
        for (a = [0, 90]) rotate([0, 0, a]) translate([0, 0, 10]) cube([3.2, 0.6, 2.4], center = true);
    }
}

if (peca == "inserto") color("#c9a227") inserto();
else if (peca == "grub") color("#b8bcc2") grub();
else color("#b8bcc2") escareado();
