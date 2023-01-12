addpath(genpath('MNPBEM17'));
%parpool('IdleTimeout', Inf);
clear
%%  electron beam
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'eels.refine', 2 );
%  table of dielectric function
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) }

%INSERT INITIALIZATION FOR SYSTEM HERE

%  width of electron beam and electron velocity
[ width, vel ] = deal( 2, eelsbase.ene2vel( 80e3 ) );

%  impact parameter
imp = [ -50, 0 ];

%  loss energies in eV
ene = linspace( 2, 2.6, 50 );
    
%  convert energies to nm
units;  enei = eV2nm ./ ene;

exc = electronbeam( p, imp, width, vel, op );
%%  BEM SOLVER

bem = bemsolver( p, op );

%  surface loss
[ psurf, pbulk ] = deal( zeros( size( imp, 1), length( enei ) ) );

%  loop over energies
parfor ien = 1 : length( enei )
  %  surface charges
  sig = bem \ exc( enei( ien ) );
  %  EELS losses
  [ psurf( :, ien ), pbulk( :, ien ) ] = exc.loss( sig );
end

%% saving data

ptot = psurf + pbulk;

save('filename.mat', 'ene', 'psurf', 'pbulk', ptot');

disp('fin');
quit
