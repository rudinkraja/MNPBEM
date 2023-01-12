clear
%%  initialization
addpath(genpath('MNPBEM17'));
%parpool('IdleTimeout', Inf);
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'eels.refine', 2 );
%op.iter = bemiter.options;
%  table of dielectric functions
epstab  = { epsconst( 1 ), epstable( 'silver.dat' ) };
tic
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
toc

%%  EELS excitation                 
%  width of electron beam and electron velocity 
[ width, vel ] = deal( 1, eelsbase.ene2vel( 200e3 ) );
%  impact parameters
%  this particular configuration gives the 3 sweeps of a square array
%  1 along diagonal, 2 along the center, 3 along the edge

t = ( diameter + gap )/2;  

x1 = linspace( 0, ( n - 1 ) * t, ( n - 1 ) * t + 1 );
y1 = linspace( 0, ( m - 1 ) * t, ( m - 1 ) * t + 1 );

x2 = linspace( 0, ( n - 1 ) * t, ( n - 1 ) * t + 1 );
y2 = linspace( ( m - 1) * t, ( m - 1 ) * t, ( m - 1 ) * t + 1 );

x3 = linspace( 0, ( n - 1 ) * t, ( n - 1 ) * t + 1 );
y3 = linspace( -25, -25, ( n - 1 ) * t + 1 );


imp = [ x1( : ), y1( : ); x2( : ), y2( : ); x3( : ), y3( : ) ];

%  loss energies in eV
ene = linspace( 2, 4, 100 );
disp(ene);
%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM simulation
%  BEM solver
bem = bemsolver( p, op );
%  electron beam excitation
exc = electronbeam( p, imp, width, vel, op );

%  surface and bulk loss
[ psurf, pbulk ] = deal( zeros( size( imp, 1 ), numel( enei ) ) );


%  loop over energies
parfor ien = 1 : length( ene )
  %  surface charges
  sig = bem \ exc( enei( ien ) );
  %  EELS losses
  [ psurf( :, ien ), pbulk( :, ien ) ] = exc.loss( sig );
  
  
end


%%  final plot
save('filename.mat', 'ene', 'psurf', 'pbulk');
disp('fin');
quit
