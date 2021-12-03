%=============== Data63 =======================
T63=readtable("./Results/datacomb/data63comb.xlsx");
T63mix=readtable("./mix_Results/data63.xlsx");

h63=figure;
p=plot(T63{:,"s"},T63{:,13:17},"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

title("Data63");
xlabel("s");
ylabel("Integrality Gap");
legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW");

set(h63,'Units','Inches');
pos = get(h63,'Position');
set(h63,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63,'./graph/data63_continuous','-dpdf','-r0');

%=============== Data63 END =======================

%=============== Data90 =======================
T90=readtable("./Results/datacomb/data90comb.xlsx");
T90mix=readtable("./mix_Results/data90.xlsx");

h90=figure;
p=plot(T90{:,"s"},T90{:,13:17},"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

title("Data90");
xlabel("s");
ylabel("Integrality Gap");
legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW");

set(h90,'Units','Inches');
pos = get(h90,'Position');
set(h90,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90,'./graph/data90_continuous','-dpdf','-r0');

%=============== Data90 END =======================

%=============== Data124 =======================
T124=readtable("./Results/datacomb/data124comb.xlsx");
T124mix=readtable("./mix_Results/data124.xlsx");

h124=figure;
p=plot(T124{:,"s"},T124{:,13:17},"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

title("Data124");
xlabel("s");
ylabel("Integrality Gap");
legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW");

set(h124,'Units','Inches');
pos = get(h124,'Position');
set(h124,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124,'./graph/data124_continuous','-dpdf','-r0');

%=============== Data124 END =======================