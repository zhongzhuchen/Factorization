%=============== Data63 mix DDFact Linx=======================
T63mix=readtable("./mix_Results/data63.xlsx");
h63mix=figure;
h63mix.Position(3:4)=[1000,400];
p=plot(T63mix{13:39,"s"},T63mix{13:39,6:8},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
p(3).Color='#7E2F8E';
p(3).LineStyle="--";
% title("Data63 mix DDFact & Linx");
xlabel("s");
ylabel("Integrality Gap");
xlim([14,40]);
legend("DDFact", "Linx","Mix\_DDFact\_Linx","location","northeastoutside");
set(h63mix,'Units','Inches');
pos = get(h63mix,'Position');
set(h63mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63mix,'./graph/data63_mix','-dpdf','-r0');

%=============== Data63 END =======================

%=============== Data90 mix DDFact Linx =======================

T90mix=readtable("./mix_Results/data90.xlsx");
h90mix=figure;
h90mix.Position(3:4)=[1000,400];
p=plot(T90mix{33:63,"s"},T90mix{33:63,6:8},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
p(3).Color='#7E2F8E';
p(3).LineStyle="--";
% title("Data90 mix DDFact & Linx");
xlabel("s");
ylabel("Integrality Gap");
xlim([34,64]);
legend("DDFact", "Linx","Mix\_DDFac\_Linx","location","northeastoutside");
set(h90mix,'Units','Inches');
pos = get(h90mix,'Position');
set(h90mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90mix,'./graph/data90_mix','-dpdf','-r0');

%=============== Data90 END =======================

% %=============== Data124 =======================
% 
% T124mix=readtable("./mix_Results/data124.xlsx");
% h124mix=figure;
% 
% h124mix.Position(3:4)=[850,400];
% 
% p=plot(T124mix{35:90,"s"},T124mix{35:90,9:14},"LineWidth",1.5);
% p(1).Color='#0072BD';
% p(2).Color='#D95319';
% p(3).Color='#EDB120';
% p(4).Color='#7E2F8E';
% p(5).Color='#77AC30';
% p(6).Color='#4DBEEE';
% 
% p(4).LineStyle="--";
% p(5).LineStyle="--";
% p(6).LineStyle="--";
% 
% % title("Data124 mix");
% xlabel("s");
% ylabel("Integrality Gap");
% legend("DDFact", "DDFactcomp","Linx", "Mix DDFact\_DDFactcomp","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx",...
%     'location','east');
% set(h124mix,'Units','Inches');
% pos = get(h124mix,'Position');
% set(h124mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(h124mix,'./graph/data124_mix','-dpdf','-r0');



%=============== Data124 =======================

T124mix=readtable("./mix_Results/data124.xlsx");

h124mix=figure;
h124mix.Position(3:4)=[1000,400];

t = tiledlayout('flow','TileSpacing','compact');
nexttile;
% h124mix=figure;
% h124mix.Position(3:4)=[425,200];
p1=plot(T124mix{44:70,"s"},T124mix{44:70,[9,10,12]},"LineWidth",1.5);
p1(1).Color='#0072BD';
p1(2).Color='#D95319';
p1(3).Color='#7E2F8E';

p1(3).LineStyle="--";
xlim([45,71]);
xlabel("s");
ylabel("Integrality Gap");

nexttile;
% h124mix=figure;
% h124mix.Position(3:4)=[425,200];
p2=plot(T124mix{38:45,"s"},T124mix{38:45,[9,11,13]},"LineWidth",1.5);
p2(1).Color='#0072BD';
p2(2).Color='#EDB120';
p2(3).Color='#77AC30';

p2(3).LineStyle="--";
xlim([39,46]);
xlabel("s");
ylabel("Integrality Gap");

nexttile;
plot(NaN,NaN,"LineWidth",1.5,"Color",'#0072BD');
hold on;
plot(T124mix{70:89,"s"},T124mix{70:89,10},"LineWidth",1.5,'Color','#D95319');
plot(T124mix{70:89,"s"},T124mix{70:89,11},"LineWidth",1.5,'Color','#EDB120');
plot(NaN,NaN,"LineWidth",1.5,"Color",'#7E2F8E','LineStyle',"--");
plot(NaN,NaN,"LineWidth",1.5,"Color",'#77AC30','LineStyle',"--");
plot(T124mix{70:89,"s"},T124mix{70:89,14},"LineWidth",1.5,'Color','#4DBEEE','LineStyle',"--");
xlim([71,90]);
xlabel("s");
ylabel("Integrality Gap");


lgd=legend("DDFact", "DDFactcomp","Linx", "Mix DDFact\_DDFactcomp","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx");
lgd.Layout.Tile = 4;
set(h124mix,'Units','Inches');
pos = get(h124mix,'Position');
set(h124mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124mix,'./graph/data124_mix','-dpdf','-r0');