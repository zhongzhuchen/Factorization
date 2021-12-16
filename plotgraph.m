%=============== Data63 =======================
T63=readtable("./Results/data63.xlsx");
T63H=readtable("./Results/dataH63.xlsx");

h63=figure;
h63.Position(3:4)=[1000,400];
p=plot(T63{:,"s"},[T63{:,11:12},T63H{:,5}],"LineWidth",1.5);
p(1).LineStyle="-";
p(3).LineStyle="-";
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
% title("Data63 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
xlim([2,62]);
ylim([0,2.6])

legend("DDFact", "DDFactcomp","Linx","location","northeastoutside");

set(h63,'Units','Inches');
pos = get(h63,'Position');
set(h63,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63,'./graph/data63_continuous','-dpdf','-r0');


%=============== Data63 END =======================
%=============== Data90 =======================
T90=readtable("./Results/data90.xlsx");
T90H=readtable("./Results/dataH90.xlsx");

h90=figure;
h90.Position(3:4)=[1000,400];
p=plot(T90{:,"s"},[T90{:,11:12},T90H{:,5}],"LineWidth",1.5);
p(1).LineStyle="-";
p(3).LineStyle="-";
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
% title("Data90 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
xlim([2,89]);
ylim([0,4.3])

legend("DDFact", "DDFactcomp","Linx","location","northeastoutside");

set(h90,'Units','Inches');
pos = get(h90,'Position');
set(h90,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90,'./graph/data90_continuous','-dpdf','-r0');


%=============== Data90 END =======================
%=============== Data124 =======================
T124=readtable("./Results/data124.xlsx");
T124H=readtable("./Results/dataH124.xlsx");

h124=figure;
h124.Position(3:4)=[1000,400];
p=plot(T124{:,"s"},[T124{:,11:12},T124H{:,5}],"LineWidth",1.5);
p(1).LineStyle="-";
p(3).LineStyle="-";
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
% title("Data124 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
xlim([2,123]);
ylim([0,6.2])
legend("DDFact", "DDFactcomp","Linx","location","northeastoutside");

set(h124,'Units','Inches');
pos = get(h124,'Position');
set(h124,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124,'./graph/data124_continuous','-dpdf','-r0');

%=============== Data124 END =======================

%=============== Data2000 =======================
T2000=readtable("./Results/data2000.xlsx");
T2000H=readtable("./Results/dataH2000.xlsx");

h2000=figure;
h2000.Position(3:4)=[1000,400];
p=plot(T2000{:,"s"},[T2000{:,7},T2000H{:,5}],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
xlabel("s");
ylabel("Integrality Gap");
legend("DDFact","Linx","location","northeastoutside");

set(h2000,'Units','Inches');
pos = get(h2000,'Position');
set(h2000,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000,'./graph/data2000_continuous','-dpdf','-r0');

%=============== Data124 END =======================