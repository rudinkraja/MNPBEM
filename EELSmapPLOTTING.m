%%  Unfolding HALF (use if system has 1 axis of symmetry)
A = filename 
B = flip(A,2)
C = [ A B]

imagesc( C );

axis equal off
colormap jet( 255 );
%% Unfolding QUARTER (use if system has 2 axes of symmetry)
A = filename

B = flip(A,2);
D = flip(A,1);
E = flip( D, 2 );

C = [ A B; D E];


imagesc( A );

axis equal off
colormap jet( 255 );