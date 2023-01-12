addpath(genpath('MNPBEM17'));
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'eels.refine', 2 );
epstab  = { epsconst( 1 ), epstable( 'silver.dat' ) };
diameter = 40;
gap = 2;
s = diameter + gap;
%number of elements( 32, 60, 144, 169, 225, 256 ... 1444)
elements = 144;
% rows (in the x direction)
n = 2;
% coluums (in the y direction)
m = 2;

pARRAY = cell(1, n * m);
eARRAY = zeros(n * m, 2);
bARRAY = zeros(1, n * m);

p0 = trisphere( elements, diameter);

w = 1;

%creating 2D structure
 for k = 0 : m - 1
     for i = 0 : n - 1
        my_field = strcat('v',num2str(k+1),num2str(i+1));
        p.(my_field) = shift( p0, [ s * i, s * k, 0 ] );
        pARRAY{w} = p.(my_field);
        eARRAY(w, 1) = 2;
        eARRAY(w, 2) = 1;
	bARRAY(1, w) = w;
        w = w + 1;
     end
 end
%  make particle
p = comparticle( epstab, { pARRAY{ 1, : } } , eARRAY , bARRAY, op );

plot(p,agArray2x2surfaceCharge_3_697_21_21)

limits = [-.01 0.01];
caxis(limits)

map1 = [ 1,	0,	0
1,	0.04,	0.04
1,	0.08,	0.08
1,	0.12,	0.12
1,	0.16,	0.16
1,	0.2,	0.2
1,	0.24,	0.24
1,	0.28,	0.28
1,	0.32,	0.32
1,	0.36,	0.36
1,	0.4,	0.4
1,	0.44,	0.44
1,	0.48,	0.48
1,	0.52,	0.52
1,	0.56,	0.56
1,	0.6,	0.6
1,	0.64,	0.64
1,	0.68,	0.68
1,	0.72,	0.72
1,	0.76,	0.76
1,	0.8,	0.8
1,	0.84,	0.84
1,	0.88,	0.88
1,	0.92,	0.92
1,	0.96,	0.96
1,	1,	1
0.96,	0.96,	1
0.92,	0.92,	1
0.88,	0.88,	1
0.84,	0.84,	1
0.8,	0.8,	1
0.76,	0.76,	1
0.72,	0.72,	1
0.68,	0.68,	1
0.64,	0.64,	1
0.6,	0.6,	1
0.56,	0.56,	1
0.52,	0.52,	1
0.48,	0.48,	1
0.44,	0.44,	1
0.4,	0.4,	1
0.36,	0.36,	1
0.32,	0.32,	1
0.28,	0.28,	1
0.24,	0.24,	1
0.2,	0.2,	1
0.16,	0.16,	1
0.12,	0.12,	1
0.08,	0.08,	1
0.04,	0.04,	1
0,	0,	1];

map = flip(map1)
material dull 
colormap(map)