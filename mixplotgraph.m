%=============== Data63 mix DDFact Linx=======================
T63mix=readtable("./mix_Results/data63.xlsx");
h63mix=figure;
p=plot(T63mix{13:39,"s"},T63mix{13:39,6:8},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
p(3).Color='#7E2F8E';

title("Data63 mix DDFact & Linx");
xlabel("s");
ylabel("Integrality Gap");
xlim([12,42]);
legend("DDFact", "Linx","Mix",'FontSize',7);
set(h63mix,'Units','Inches');
pos = get(h63mix,'Position');
set(h63mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63mix,'./graph/data63_mix','-dpdf','-r0');

%=============== Data63 END =======================

%=============== Data90 mix DDFact Linx =======================

T90mix=readtable("./mix_Results/data90.xlsx");
h90mix=figure;
p=plot(T90mix{33:63,"s"},T90mix{33:63,6:8},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
p(3).Color='#7E2F8E';

title("Data90 mix DDFact & Linx");
xlabel("s");
ylabel("Integrality Gap");
xlim([31,66]);
legend("DDFact", "Linx","Mix",'FontSize',7);
set(h90mix,'Units','Inches');
pos = get(h90mix,'Position');
set(h90mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90mix,'./graph/data90_mix','-dpdf','-r0');

%=============== Data90 END =======================

%=============== Data124 =======================

T124mix=readtable("./mix_Results/data124.xlsx");
h124mix=figure;
p=plot(T124mix{:,"s"},T124mix{:,9:14},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';
p(6).Color='#4DBEEE';

p(4).LineStyle="--";
p(5).LineStyle="--";
p(6).LineStyle="--";

title("Data124 mix");
xlabel("s");
ylabel("Integrality Gap");
xlim([0,125]);
legend("DDFact", "DDFactcomp","Linx", "Mix DDFact\_DDFactcomp","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx",...
    'FontSize',7,'location','South');
set(h124mix,'Units','Inches');
pos = get(h124mix,'Position');
set(h124mix,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124mix,'./graph/data124_mix','-dpdf','-r0');