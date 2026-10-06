# Porta-amostras de 30 mm para pastilhas prensadas de 13 mm (LA-ICP-MS / LIBS)

É um cilindro com a seção de 30 mm que o porta-amostras do equipamento já aceita, com cavidades para
pastilhas de 13 mm. Segue a mesma ideia dos porta-amostras de seções polidas de MEV: a pastilha fica
**presa mecanicamente**, mesmo com o porta-amostras inclinado, e a **altura de cada pastilha é
ajustável**, de modo que todas as faces de análise ficam no mesmo plano. Não usa resina e não precisa
de polimento.

![Conjunto para 3 pastilhas com tampa de fixação](img/conjunto_3x13mm_tampa.png)

## Ajuste de altura (todas as versões)

Cada cavidade tem um **pistão** (disco solto de 12,9 mm) sob a pastilha. Um **parafuso M3 sem cabeça**,
que entra por baixo, empurra o pistão para cima. Cada pastilha é regulada de forma independente, o que
compensa a diferença de espessura entre elas. O mesmo parafuso serve para extrair a pastilha.

## Fixação: duas opções

### A) Tampa de fixação (`fixacao = "tampa"`): recomendada; serve para 1, 2 ou 3 pastilhas

![Tampa](img/tampa_3x13mm.png)

- A tampa é presa com parafusos M2 de cabeça chata escareada. Ela tem janelas de 11,8 mm, e a borda de
  cada janela cobre **0,6 mm** da borda da pastilha.
- Ao apertar o parafuso de baixo, a pastilha sobe até encostar na borda da janela. Isso **prende e
  nivela ao mesmo tempo**: todas as faces ficam encostadas no mesmo plano (a face inferior da tampa),
  seja qual for a espessura de cada pastilha.
- A face de análise fica 1,5 mm abaixo do topo. A janela tem chanfro, o que deixa espaço para o feixe e
  para o plasma com o porta-amostras inclinado.
- Área útil: círculo de ~11,8 mm em cada pastilha.

**Montagem:**
1. Coloque o pistão e a pastilha (face para cima) em cada cavidade.
2. Parafuse a tampa.
3. Por baixo, aperte cada parafuso M3 até a pastilha encostar na tampa. Encostou e travou, pare: o
   aperto deve ser leve, para não trincar a pastilha. Se quiser amortecer, coloque um disco fino de
   silicone ou de papel entre o pistão e a pastilha.

### B) Parafuso lateral com calço (`fixacao = "lateral"`): só para 1 ou 2 pastilhas

![Base com parafuso lateral](img/base_2x13mm_lateral.png)

![Como funciona o parafuso lateral: corte e vista de cima](img/desenho_parafuso_lateral.png)

- Um parafuso M3 sem cabeça entra pela lateral do cilindro, como nos porta-amostras de MEV, e empurra um
  **calço de nylon ou PTFE** (Ø 2,3 × 2,5 mm) contra a borda da pastilha.
- A face fica **rente ao topo**, e nenhuma parte da pastilha fica coberta.
- O furo lateral está a 2 mm abaixo do topo, então a pastilha precisa ter **pelo menos ~2 mm de
  espessura** para o calço alcançá-la. Para pastilhas mais finas, use a versão com tampa.
- **Com 3 pastilhas não é possível:** três círculos de 13 mm ocupam quase todo o círculo de 30 mm e a
  parede da borda fica com ~0,5 mm, sem espaço para rosca.

**Montagem e nivelamento:**
1. Apoie uma lâmina de vidro limpa na bancada e coloque as pastilhas sobre ela com a face de análise
   para baixo.
2. Encaixe a base por cima, de cabeça para baixo.
3. Coloque os pistões e aperte os parafusos de baixo só até encostar.
4. Aperte os parafusos laterais.
5. Vire o conjunto. As faces ficam rentes ao topo e no mesmo plano.

## Arquivos

| Arquivo | Peça |
|---|---|
| `porta_amostras_30mm.scad` | Modelo paramétrico (OpenSCAD). Abra em *Window → Customizer* para mudar as medidas. |
| `stl/base_3x13mm_tampa.stl` + `stl/tampa_3x13mm.stl` | 3 pastilhas, fixação por tampa (3 parafusos M2) |
| `stl/base_2x13mm_tampa.stl` + `stl/tampa_2x13mm.stl` | 2 pastilhas, fixação por tampa (2 parafusos M2) |
| `stl/base_2x13mm_lateral.stl` | 2 pastilhas, parafuso lateral |
| `stl/base_1x13mm_lateral.stl` | 1 pastilha, parafuso lateral |
| `stl/pistao_13mm.stl` | Pistão (um por cavidade) |
| `stl/calco_lateral.stl` | Calço do parafuso lateral; de preferência, corte de um tarugo de nylon ou PTFE |

### Parafusos (por suporte)

| Versão | Fundo (altura) | Fixação |
|---|---|---|
| Tampa, 3 pastilhas | 3 × M3 sem cabeça (DIN 913), 8–10 mm | 3 × M2 × 8 cabeça chata (DIN 965) |
| Tampa, 2 pastilhas | 2 × M3 sem cabeça, 8–10 mm | 2 × M2 × 8 cabeça chata |
| Lateral, 2 pastilhas | 2 × M3 sem cabeça, 8–10 mm | 2 × M3 sem cabeça, 6 mm, + 2 calços |

### Medidas padrão

- Ø externo 29,9 mm e altura total de 10 mm (com tampa: base de 8,5 mm + tampa de 1,5 mm).
- Cavidades de Ø 13,1 mm.
- Espessura máxima de pastilha: 3,5 mm na versão com tampa e 5 mm na versão lateral.

**Antes de fabricar, confira** a altura máxima que o porta-amostras do equipamento aceita e altere
`altura`, se precisar.

## Fabricação

- **Versão para 3 pastilhas:** a parede da borda fica com ~0,5 mm. Usine em alumínio, PEEK ou POM
  (Delrin), ou imprima em resina SLA. Não use impressão FDM.
- **Tampa:** fica melhor em metal fino, como alumínio ou inox de 1,5 mm cortado a laser ou usinado,
  depois escareado.
- **Versões para 2 ou 1 pastilha:** são mais robustas e podem ser impressas em FDM (PETG) para teste.
- **Furos:** os de 2,5 mm são para abrir rosca M3 com macho, e os de 1,6 mm na base, para rosca M2. Em
  peça impressa, prefira insertos metálicos (aumente o furo conforme o inserto).
- **Teste de encaixe:** faça antes com uma pastilha real. `folga_pastilha` = 0,05–0,15 mm para usinagem
  e 0,15–0,25 mm para impressão.

## Contaminação

Só a pastilha é ablada. O suporte, a tampa e o calço não entram no plasma, desde que o laser não seja
posicionado na borda da janela. Recomenda-se:

- limpar as peças em ultrassom (água ultrapura / etanol) entre usos;
- fazer pré-ablação (pulsos de limpeza) antes da aquisição.

## Regenerar os STL

```sh
openscad -o stl/base_3x13mm_tampa.stl   -D 'peca="base"'  -D n_pastilhas=3 porta_amostras_30mm.scad
openscad -o stl/tampa_3x13mm.stl        -D 'peca="tampa"' -D n_pastilhas=3 porta_amostras_30mm.scad
openscad -o stl/base_2x13mm_lateral.stl -D 'peca="base"'  -D n_pastilhas=2 -D 'fixacao="lateral"' porta_amostras_30mm.scad
openscad -o stl/pistao_13mm.stl         -D 'peca="pistao"' porta_amostras_30mm.scad
```
