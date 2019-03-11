 function terminal_flow(in, sys, module)



%% AC Power Flow
 if module == 1
	b = sys.base;
	A = [sys.branch(:,1)  sys.branch(:,9)  real(in.branch(:,5))*b  imag(in.branch(:,5))*b  real(in.branch(:,6))*b  imag(in.branch(:,6))*b  sys.branch(:,10) ...
		(in.branch(:,9)+in.branch(:,10))*b  real(in.branch(:,11))*b  imag(in.branch(:,11))*b];

	disp(' ')
	disp('   _____________________________________________________________________________________________________________________________________________')
	disp('  |                            Active and Reactive Power Flow                               |     Injection     |     Series Impedance Loss     |')
	disp('  |                                                                                         |                   |                               |')
	disp('  |     No.      From Bus       P[MW]  |  Q[MVAr]         P[MW]  |  Q[MVAr]      To Bus     |      Q[MVAr]      |       P[MW]  |  Q[MVAr]       |')
	disp('  |-----------------------------------------------------------------------------------------|-------------------|-------------------------------|')
	fprintf('  |\t    %-8.f %6.f %13.2f %11.2f %13.2f %11.2f %10.f      | %12.2f      | %11.2f %11.2f\t    |\n', A')
	disp('  |-----------------------------------------------------------------------------------------|-------------------|-------------------------------|')
	fprintf('  |\tSum %83s | %12.2f      | %11.2f %11.2f\t    |\n', [], sum(in.branch(:,9)+in.branch(:,10))*b, sum(real(in.branch(:,11))*b), sum(imag(in.branch(:,11))*b))
	disp('  |_________________________________________________________________________________________|___________________|_______________________________|')
 end

%% DC Power Flow
 if module == 2 || module == 3
	b = sys.base;
	a = 1:sys.Nbr;
	A = [sys.branch(a,1)  sys.branch(a,9)  in.branch(a,1)*b  -in.branch(a,1)*b  sys.branch(a,10)];

	disp(' ')
	disp('   _________________________________________________________________')
	disp('  |                       Active Power Flow                         |')
	disp('  |                                                                 |')
	disp('  |     No.      From Bus       P[MW]         P[MW]      To Bus     | ')
	disp('  |-----------------------------------------------------------------|')
	fprintf('  |\t    %-8.f %6.f %13.2f %13.2f %10.f      |\n', A')
	disp('  |-----------------------------------------------------------------|')
	disp('  |_________________________________________________________________|')
 end