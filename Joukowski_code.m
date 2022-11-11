clear all;

%% Taking Joukowski Profile

%characteristics of NACA2412 with chord length 4 (Just to demostrate)
%dataMaxTickness = 0.48 %4*0.12
%dataMaxCamber = 0.08 %4*0.02
%dataMaxCamberLoc = 1.6 %4*0.4

%Values to iterate through
realValues = linspace(0.07,0.1,300); %range shortened in approximate region
imagValues = linspace(0.025,0.055,300); %range shortened in approximate region
n = 500;
min_thickness_residual = intmax;
min_camber_residual = intmax;

for realPart = realValues
    for imagPart = imagValues
        cen = realPart+(imagPart)*i;
        l = sqrt(1-imag(cen)^2) + real(cen);
        
        theta = linspace(0,2*pi-2*pi/n,n);
        Zeta= cos(theta)+i*sin(theta);

        Z = (Zeta+cen) + (l^2)./(Zeta+cen);
        Z_camberline = (Zeta+(imag(cen)*i)) + ((l-real(cen))^2)./(Zeta+(imag(cen)*i));
        
        chordLength = (l+l) + ((l-2*real(cen)) + (l^2)/(l-2*real(cen)))
        %characteristics of NACA2412 with a given chord length
        dataMaxTickness = chordLength*0.12;
        dataMaxCamber = chordLength*0.02;
        dataMaxCamberLoc = chordLength*0.4;%Couldn't use as the max camber occurs at mid point
        
        [maxCamber, maxCamberInd] = max(imag(Z_camberline));
        %maxCamberPnt = Z_camberline(maxCamberInd);
        %finding maximum thickness
        maxThickness = 0;
        tolerance_1 = 0.2;
        for zValues_1 = Z
            for zValues_2 = Z
                if abs(real(zValues_1)-real(zValues_2))<tolerance_1
                    thicknessTemp = abs(imag(zValues_1)-imag(zValues_2));
                    if thicknessTemp > maxThickness
                        maxThickness = thicknessTemp;
                    end
                end
            end
        end
        camber_residual = abs(dataMaxCamber - maxCamber);
        if camber_residual < min_camber_residual
            min_camber_residual = camber_residual;
            finalImagPart = imagPart;
        end
        thickness_residual = abs(dataMaxTickness - maxThickness);
        if thickness_residual < min_thickness_residual
            min_thickness_residual = thickness_residual;
            finalRealPart = realPart;
        end                
    end
end

final_Cen = finalRealPart+(finalImagPart)*i;
l = sqrt(1-imag(final_Cen)^2) + real(final_Cen);
theta = linspace(0,2*pi-2*pi/n,n);
Zeta= cos(theta)+i*sin(theta);

Z = (Zeta+final_Cen) + (l^2)./(Zeta+final_Cen);
Z_camberline = (Zeta+(imag(final_Cen)*i)) + ((l-real(final_Cen))^2)./(Zeta+(imag(final_Cen)*i));

chordLength = (l+l) + ((l-2*real(final_Cen)) + (l^2)/(l-2*real(final_Cen)))
%characteristics of NACA2412 with a given chord length
dataMaxTickness = chordLength*0.12;
dataMaxCamber = chordLength*0.02;
dataMaxCamberLoc = chordLength*0.4;%Couldn't use as the max camber occurs at mid point

[maxCamber, maxCamberInd] = max(imag(Z_camberline));
maxCamberPnt = Z_camberline(maxCamberInd);        

figure
plot(Z);
hold on
plot(Z_camberline)
plot(final_Cen-Zeta)
%plot(Zeta)
axis equal
plot(final_Cen,'rx','LineWidth',2)
hold off;
title('Conformal mapping')

%% Plotting Alpha vs Cl
%consider Angle of attaks from -20 to 20
alpha = linspace(-20*pi/180,20*pi/180,40);
beta = pi-(atan(imag(final_Cen)/real(final_Cen)));
%By derived equation,
Lift_coeff = (8*pi*(1)*sin(beta-alpha))/chordLength;

figure
plot(alpha,Lift_coeff)
title('Alpha vs Cl')
%Beep to know when the code finishes running
sound(0.75*sin(2*pi*1000*(0:1/20500:0.15)));

