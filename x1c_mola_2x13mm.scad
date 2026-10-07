// Segundo modelo: porta-amostras de 30 mm para 2 pastilhas de 13 mm com
// ajuste de altura por MOLA (Bambu Lab X1C, PC).
//
// Cada pastilha apoia num pistão empurrado por uma mola de compressão.
// Ao parafusar a tampa, as molas comprimem e mantêm cada pastilha
// pressionada contra a borda da janela: todas ficam no mesmo plano, sem
// nenhum ajuste manual, para qualquer espessura entre 1 e 4 mm.
//
// Usa o preset FDM (folgas de PC, insertos M3 da tampa) e troca o fundo
// com parafuso por poços de mola.

include <x1c_fdm.scad>

/* [Peça] */
peca = "conjunto"; // [base, tampa, pistao, conjunto]
fixacao = "tampa";
ajuste = "mola";
n_pastilhas = 2;
material = "PC"; // [PC, PETG]

// Altura total: confira o máximo que o porta-amostras do equipamento aceita
altura = 13;

// Faixa de espessura das pastilhas
espessura_min_pastilha = 1;
espessura_max_pastilha = 4;

// Fundo abaixo do poço da mola e pistão com pino-guia
espessura_fundo = 1.5;
espessura_pistao = 2;

// Mola de compressão inox: Ø externo 6 mm, livre 10 mm, sólida <= 3 mm (fio 0,4–0,5 mm)
d_mola = 6;
comprimento_livre_mola = 10;
comprimento_solido_mola = 3;
