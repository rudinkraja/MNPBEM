%  BEM options
op = bemoptions( 'sim', 'ret' );
%  triangular particle
p1 = trisphere( 160, 32 );
p2 = shift( p1, 165 );
%  make COMPARTICLE object
p = comparticle( { epsconst( 1 ), epstable( 'silver.dat' ) }, { p1, p2 }, [ 2, 1 ; 2, 1 ], 1, 2, op );

%  wavelength (load UNITS for conversion from eV to nm)
units;  enei = eV2nm ./ 3.70;
%  mesh for electron beams (this gives the resolution and symmetry 
%  if the system is symmetric in x and y, you can do only a quarter of it
%  and unfold using EELSmapPLOTTING.m
[ x, y ] = meshgrid( linspace( -85, 245, 330 ), linspace( -85, 85, 170 ) );
%  EELS excitation
exc = electronbeam( p, [ x( : ), y( : ) ], 0.2, 0.7, op );

%  set up BEM solver
bem = bemsolver( p, op );
%  compute surface charge
sig = bem \ exc( enei );
%  surface and bulk losses
[ psurf, pbulk ] = exc.loss( sig );

ptot = psurf + pbulk;
EELSmap = reshape( ptot, size( x ) );

save('AuDipole3_7eV.mat', 'EELSmap');

% %  final plot
% imagesc( a );
% 
% axis equal off
% colormap jet( 255 );