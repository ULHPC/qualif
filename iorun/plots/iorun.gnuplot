################################################################################
# lustre_perf.gnuplot - Configuration file for Gnuplot (see http://www.gnuplot.info)
# Creation : 28 Jan 2014
# Time-stamp: <Lun 2014-01-28 19:40 hcartiaux>
#
# Copyright (c) 2013 Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>
# $Id$
#
# More infos and tips on Gnuplot:
#    - http://t16web.lanl.gov/Kawano/gnuplot/index-e.html
#    - run gnuplot the type 'help gnuplot_command'
#
# To run this script : gnuplot benchmark_network.gnuplot
################################################################################

set encoding iso_8859_15
#########################################################################################
# Formats de sortie
# - Par défaut : sur X11
# - LaTeX (permet d'utiliser le format LaTeX $expr$ pour les formules)
#set terminal latex
#set output "outputfile.tex"
# - EPS
set terminal postscript eps enhanced color
#set output "outputfile.eps"
# - PDF
#set terminal pdf enhanced
#########################################################################################

#########################################################################################
# Gestion de l'affichage des axes, des legendes etc....
#
#set title  "Lustre filesystem benchmark"     # Titre du graphique

# -- Gestion des axes --
set xlabel "Number of nodes"
set ylabel "I/O bandwidth (MiB/s)"    # Label Axe Y (avec 2 axes: set y{1|2}label)
set border 3           # format d'affichage des bordures (Valeur du paramètre: voir Tab.4 plus bas)
# set xrange [0:33]    # Intervalle Axe X
# set yrange [0:3000]     # Intervalle Axe Y
set xtics 5            # intervalle entre les graduations de l'axe X
set ytics 500            # intervalle entre les graduations de l'axe Y
set xtics nomirror    # Pas de reflexion de l'axe X en haut
set ytics nomirror    # Pas de reflexion de l'axe Y à droite
set grid              # affichage d'une grille pour les graduations majeures

# -- Positionnement/affichage des legendes des courbes --
#set nokey             # Pas de légende
set key right bottom
#set key bottom   # Placé les légendes en bas à gauche
#set key box            # Encadrer les légendes
set size 0.8,0.6

#########################################################################################




####################################################################################################
# Dessin à partir d'un fichier de données
# Remarques :
#  - les séparateur de champs sont nécessairement ' '* ou une tabulation
#  - les colonnes sont numérotées de 1 à n (cf clause using)
set output "iorun.eps"

# set style line <index> {{linetype  | lt} <line_type> | <colorspec>}
#                               {{linecolor | lc} <colorspec>}
#                               {{linewidth | lw} <line_width>}
#                               {{pointtype | pt} <point_type>}
#                               {{pointsize | ps} <point_size>}
#                               {{pointinterval | pi} <interval>}
#                               {palette}

set style line 1 lw 3 pt 2 linecolor rgb "blue"
set style line 2 lw 3 pt 4 linecolor rgb "red"
set style line 3 lt 2 lw 4 linecolor rgb "black"
set style line 4 lt 5 lw 4 linecolor rgb "magenta"

plot	"iorun.dat"  using 1:2  title "Write, filesize 20G" with linespoints ls 1, \
    	"iorun.dat" using 1:3  title "Read, filesize 20G"  with linespoints ls 2

#i#################
# Gnuplot Infos:
#
# [Tab. 1] Liste des fonctions reconnues par Gnuplot :
# ----------------------------------------------------
#   abs    valeur absolue
#   acos   arc cosinus
#   asin   arc sinus
#   atan   arc tangente
#   cos    cosinus
#   exp    exponentiel
#   int    renvoi la partie  entière de son argument
#   log    logarithme
#   log10  logarithme en base 10
#   rand   random (renvoi un nombre entre 0 et 1)
#   real   partie real
#   sgn    renvoi 1 si l'argument est positif, 0 s'il
#          est nulle, et -1 s'il est négatif
#   sin    sinus
#   sqrt   racine carré
#   tan    tangente
#
# [Tab. 2] Operateurs reconnues par Gnuplot :
# -------------------------------------------
#    Symbole      Exemple         Explication
#     **           a**b           exponentiation
#     *            a*b            multiplication
#     /            a/b            division
#     %            a%b            modulo
#     +            a+b            addition
#     -            a-b            soustraction
#     ==           a==b           égalité
#     !=           a!=b           inégalité
#     &            a&b            ET
#     ^            a^b            OU exclusif
#     |            a|b            OU inclusif
#     &&           a&&b           ET logique
#     ||           a||b           OU logique
#     ?:           a?b:c          opération ternaire
#
# [Tab. 3] Liste des formats reconnus (instructions 'set format') :
# -----------------------------------------------------------------
#       Format       Explanation
#       %f           floating point notation
#       %e or %E     exponential notation; an "e" or "E" before the power
#       %g or %G     the shorter of %e (or %E) and %f
#       %x or %X     hex
#       %o or %O     octal
#       %t           mantissa to base 10
#       %l           mantissa to base of current logscale
#       %s           mantissa to base of current logscale; scientific power
#       %T           power to base 10
#       %L           power to base of current logscale
#       %S           scientific power
#       %c           character replacement for scientific power
#       %P           multiple of pi
#
# [Tab. 4] Valeur attribuée aux bordure (instruction 'set border <sum>') :
# ------------------------------------------------------------------------
#        Bit   axe affiché
#         1     bas         (x ou x1)
#         2     gauche      (y ou y1 )
#         4     haut        (x2)
#         8     droit       (y2)
#
# [Tab. 5] Affichage des lettres grecs en mode Postcript Ex: {/Symbol a} => \alpha
# +------------------------+--------------------+
# |  ALPHABET 	SYMBOL     | alphabet 	symbol  |
# +------------------------+--------------------+
#	A 	Alpha 	   | 	a 	alpha	|
#	B 	Beta 	   |  	b 	beta 	|
#	C 	Chi 	   |  	c 	chi 	|
#	D 	Delta 	   |  	d 	delta 	|
#	E 	Epsilon    |  	e 	epsilon |
#	F 	Phi  	   |  	f 	phi 	|
#	G 	Gamma 	   | 	g 	gamma 	|
#	H 	Eta 	   |  	h 	eta 	|
#	I 	iota 	   | 	i 	iota 	|
#	K 	Kappa 	   | 	k 	kappa 	|
#	L 	Lambda 	   |  	l 	lambda 	|
#	M 	Mu 	   | 	m 	mu 	|
#	N     	Nu         |  	n       nu   	|
#	O     	Omicron    |    o       omicron |
#	P     	Pi   	   |    p       pi	|
#	Q     	Theta 	   |  	q       theta	|
#	R     	Rho  	   |   	r       rho     |
#	S     	Sigma 	   | 	s       sigma	|
#	T     	Tau 	   | 	t       tau	|
#	U     	Upsilon	   |	u       upsilon	|
#	W     	Omega 	   |	w       omega	|
#	X     	Xi 	   |	x       xi	|
#	Y     	Psi 	   |	y       psi	|
#	Z     	Zeta 	   |	z       zeta	|




