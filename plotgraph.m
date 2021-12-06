%=============== Data63 =======================
T63=readtable("./Results/data63.xlsx");
T63FW=readtable("./Results/dataFW/DataFW63.xlsx");

h63=figure;
p=plot(T63{:,"s"},[T63{:,11:14},T63FW{:,11}],"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';

title("Data63 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
ylim([0,8])

legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW",'FontSize',7);

set(h63,'Units','Inches');
pos = get(h63,'Position');
set(h63,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63,'./graph/data63_continuous','-dpdf','-r0');

% ---------------  Data63 Time -----------------
h63t=figure;
pt=plot(T63{:,"s"},T63{:,36:38},"LineWidth",1.5);
pt(1).Color='#0072BD';
pt(2).Color='#D95319';
pt(3).Color='#EDB120';

title("Data63 Time");
xlabel("s");
ylabel("Time(seconds)");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h63t,'Units','Inches');
pos = get(h63t,'Position');
set(h63t,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63t,'./graph/data63_time','-dpdf','-r0');

% ---------------  Data63 FuncCount -----------------
h63c=figure;
pc=plot(T63{:,"s"},T63{:,44:46},"LineWidth",1.5);
pc(1).Color='#0072BD';
pc(2).Color='#D95319';
pc(3).Color='#EDB120';

title("Data63 FuncCount");
xlabel("s");
ylabel("FuncCount");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h63c,'Units','Inches');
pos = get(h63c,'Position');
set(h63c,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63c,'./graph/data63_funcCount','-dpdf','-r0');

%=============== Data63 END =======================

%=============== Data90 =======================
T90=readtable("./Results/data90.xlsx");
T90FW=readtable("./Results/dataFW/DataFW90.xlsx");

h90=figure;
p=plot(T90{:,"s"},[T90{:,11:14},T90FW{:,11}],"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';

title("Data90 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
ylim([0,4.5])

legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW",'FontSize',7);

set(h90,'Units','Inches');
pos = get(h90,'Position');
set(h90,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90,'./graph/data90_continuous','-dpdf','-r0');

% ---------------  Data90 Time -----------------
h90t=figure;
pt=plot(T90{:,"s"},T90{:,36:38},"LineWidth",1.5);
pt(1).Color='#0072BD';
pt(2).Color='#D95319';
pt(3).Color='#EDB120';

title("Data90 Time");
xlabel("s");
ylabel("Time(seconds)");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h90t,'Units','Inches');
pos = get(h90t,'Position');
set(h90t,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90t,'./graph/data90_time','-dpdf','-r0');

% ---------------  Data90 FuncCount -----------------
h90c=figure;
pc=plot(T90{:,"s"},T90{:,44:46},"LineWidth",1.5);
pc(1).Color='#0072BD';
pc(2).Color='#D95319';
pc(3).Color='#EDB120';

title("Data90 FuncCount");
xlabel("s");
ylabel("FuncCount");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h90c,'Units','Inches');
pos = get(h90c,'Position');
set(h90c,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90c,'./graph/data90_funcCount','-dpdf','-r0');
%=============== Data90 END =======================

%=============== Data124 =======================
T124=readtable("./Results/data124.xlsx");
T124FW=readtable("./Results/dataFW/DataFW124.xlsx");

h124=figure;
p=plot(T124{:,"s"},[T124{:,11:14},T124FW{:,11}],"LineWidth",1.5);
p(1).LineStyle="-";
p(5).LineStyle="--";
p(3).LineStyle="-";
p(4).LineStyle="--";

p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';

title("Data124 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
ylim([0,6.5])
legend("DDFact", "DDFactcomp","Linx","Linx\_SDPT3", "FW", 'FontSize',7);

set(h124,'Units','Inches');
pos = get(h124,'Position');
set(h124,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124,'./graph/data124_continuous','-dpdf','-r0');

% ---------------  Data124 Time -----------------
h124t=figure;
pt=plot(T124{:,"s"},T124{:,36:38},"LineWidth",1.5);
pt(1).Color='#0072BD';
pt(2).Color='#D95319';
pt(3).Color='#EDB120';

title("Data124 Time");
xlabel("s");
ylabel("Time(seconds)");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h124t,'Units','Inches');
pos = get(h124t,'Position');
set(h124t,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124t,'./graph/data124_time','-dpdf','-r0');

% ---------------  Data124 FuncCount -----------------
h124c=figure;
pc=plot(T124{:,"s"},T124{:,44:46},"LineWidth",1.5);
pc(1).Color='#0072BD';
pc(2).Color='#D95319';
pc(3).Color='#EDB120';

title("Data124 FuncCount");
xlabel("s");
ylabel("FuncCount");

legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h124c,'Units','Inches');
pos = get(h124c,'Position');
set(h124c,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124c,'./graph/data124_funcCount','-dpdf','-r0');
%=============== Data124 END =======================

%=============== Data2000 =======================
T2000=readtable("./Results/data2000.xlsx");
T2000FW=readtable("./Results/dataFW/DataFW2000.xlsx");

h2000=figure;
p=plot(T2000{:,"s"},[T2000{:,7:8},T2000FW{:,11}],"LineWidth",1.5);
p(1).LineStyle="-";
p(3).LineStyle="--";
p(1).Color='#0072BD';
p(2).Color='#EDB120';
p(4).Color='#77AC30';

title("Data2000 Integrality Gap");
xlabel("s");
ylabel("Integrality Gap");
legend("DDFact","Linx", "FW", 'FontSize',7);

set(h2000,'Units','Inches');
pos = get(h2000,'Position');
set(h2000,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000,'./graph/data2000_continuous','-dpdf','-r0');

% ---------------  Data2000 Time -----------------
h2000t=figure;
pt=plot(T2000{:,"s"},T2000{:,20:21},"LineWidth",1.5);
pt(1).Color='#0072BD';
pt(2).Color='#EDB120';

title("Data2000 Time");
xlabel("s");
ylabel("Time(seconds)");

legend("DDFact","Linx",'FontSize',7);

set(h2000t,'Units','Inches');
pos = get(h2000t,'Position');
set(h2000t,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000t,'./graph/data2000_time','-dpdf','-r0');

% ---------------  Data2000 FuncCount -----------------
h2000c=figure;
pc=plot(T2000{:,"s"},T2000{:,24:25},"LineWidth",1.5);
pc(1).Color='#0072BD';
pc(2).Color='#EDB120';

title("Data2000 FuncCount");
xlabel("s");
ylabel("FuncCount");
ylim([0,850]);
legend("DDFact", "DDFactcomp","Linx",'FontSize',7);

set(h2000c,'Units','Inches');
pos = get(h2000c,'Position');
set(h2000c,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000c,'./graph/data2000_funcCount','-dpdf','-r0');
%=============== Data124 END =======================