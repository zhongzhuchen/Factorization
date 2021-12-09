%=============== Data63 =======================
T63=readtable("./Results/data63.xlsx");
T63mix=readtable("./mix_Results/data63.xlsx");

h63=figure;
p=plot(T63{:,"s"},[T63{:,27:29},T63mix{:,17}],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';

p(4).LineStyle="--";

title("Data63 fixnum");
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx",'FontSize',7,'location','north');
set(h63,'Units','Inches');
pos = get(h63,'Position');
set(h63,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63,'./graph/data63_fixnum','-dpdf','-r0');
%=============== Data63 END =======================

%=============== Data90 =======================
T90=readtable("./Results/data90.xlsx");
T90mix=readtable("./mix_Results/data90.xlsx");

h90=figure;
p=plot(T90{:,"s"},[T90{:,27:29},T90mix{:,17}],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';

p(4).LineStyle="--";

title("Data90 fixnum");
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx",'FontSize',7,'location','north');
set(h90,'Units','Inches');
pos = get(h90,'Position');
set(h90,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90,'./graph/data90_fixnum','-dpdf','-r0');
%=============== Data90 END =======================

%=============== Data124 =======================
T124=readtable("./Results/data124.xlsx");
T124mix=readtable("./mix_Results/data124.xlsx");

h124=figure;
p=plot(T124{:,"s"},T124mix{:,27:32},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';
p(6).Color='#4DBEEE';

p(4).LineStyle="--";
p(5).LineStyle="--";
p(6).LineStyle="--";

title("Data124 fixnum");
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx",...
    'FontSize',7,'location','north');
set(h124,'Units','Inches');
pos = get(h124,'Position');
set(h124,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124,'./graph/data124_fixnum','-dpdf','-r0');
%=============== Data124 END =======================

%=============== Data2000 =======================
T2000=readtable("./Results/data2000.xlsx");

h2000=figure;
p=plot(T2000{:,"s"},T2000{:,15:16},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#EDB120';
title("Data2000 fixnum");
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx",...
    'FontSize',7,'location','north');
set(h2000,'Units','Inches');
pos = get(h2000,'Position');
set(h2000,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000,'./graph/data2000_fixnum','-dpdf','-r0');
%=============== Data2000 END =======================