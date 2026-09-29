# Regras básicas

## Tipos de cartas

Existem três tipos de cartas jogáveis:

1. Caster — Ao resolver, fica no campo de jogo de seu controlador. Permite a ele jogar cartas adicionais, em geral com modificações de custos ou restrições (por exemplo, de tipos de carta que podem jogar)
2. Struct — Fica em jogo e possui algum efeito que dura enquanto permanecer em jogo
3. Spell — Faz algum efeito ao resolver

Existe um tipo adicional, chamado "Concept" que pode ser atribuído a uma carta por outras cartas.

## Sequência do turno

Ao começar o jogo, os jogadores decidem aleatoriamente qual deles vai receber a *prioridade*.

Os jogadores jogam os turnos ao mesmo tempo. A cada turno, a sequência de ações é:
  
0. Os jogadores jogam, viradas para baixo, até uma carta. Caso possuam Casters em jogo, podem jogar até uma carta adicional para cada Caster. Após realizarem suas jogadas, os jogadores _o sinalizam_
1. Cartas que têm efeitos no início do turno resolvem seus efeitos.
2. Após ambos sinalizarem o fim de suas jogadas, todas as cartas viradas para baixo são voltadas para cima e colocadas na timeline nas colunas respectivas a seus custos, após as devidas modificações de custo causada pelos Casters que as jogaram e por efeitos de outras cartas
3. Todas as cartas que estão em jogo reduzem seu custo em 1, prosseguindo para a coluna seguinte.
4. Todas as cartas na coluna 0 resolvem. Caso haja cartas de mais de um jogador para serem resolvidas, o jogador que tem a prioridade resolve as suas cartas primeiro.
5. É checado se um jogador possui 10 de aura ou mais e, se for o caso, elu ganha o jogo. Se mais de um jogador possuir 10 ou mais de aura, ganha o que tiver mais aura. Se ambos possuírem a mesma quantidade de aura, o jogo termina em empate.
6. Cartas que possuem efeitos no fim do turno resolvem seus efeitos.

## Regras gerais

01. Uma carta não pode ter seu custo reduzido abaixo de 0, ou aumentado acima de 6.
02. Caso um jogador tente comprar uma carta e não consiga, seu oponente ganha +1 aura.
03. Decks devem possuir 30 cartas e, no máximo, 2 cópias de cada carta com nome distinto.
04. São colocadas no descarte de seus donos:
    - As cartas Spell imediatamente após resolverem.
    - As cartas destruídas por qualquer refeito.
    - As cartas sacrificadas.
    - As cartas descartadas.
05. Os jogadores possuem um reservatório de aura. Efeitos que dizem "O jogador _ganha_ +/- X aura" adicionam aura a essa reserva.
06. Efeitos que dizem "O jogador _tem_ +/- X aura" não a acrescentam ao reservatório de aura e são considerados efeitos de atribuição de aura. 
07. A aura total do jogador é calculada somando-se a aura acumulada em seu reservatório e a aura atribuída através de efeitos estáticos.
08. Efeitos que dizem "O jogador _ganha_ -X aura" só podem remover aura caso o jogador tenha alguma em seu reservatório. Esses efeitos não interagem com os efeitos de atribuição de aura, mencionados na regra geral **06**. Por exemplo, um jogador controla um \[Templo do Leste\], que diz "Você tem +1 aura" e seu oponente resolve a carta \[Drenar Aura\]. O jogador em questão não perde aura porque a única aura que ele possui é devida ao efeito de atribuição do \[Templo do Leste\].