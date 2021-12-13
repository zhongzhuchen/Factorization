%=============== Data63 =======================
T63fix=readtable("./mix_Results/data63fixnum.xlsx");
% data preprocessing
solve_DDFact=table2array(T63fix(:,3));
solve_DDFactcomp=table2array(T63fix(:,10));
solve_Linx=table2array(T63fix(:,17));
solve_Mix1=table2array(T63fix(:,24));
solve=(solve_DDFact+solve_DDFactcomp+solve_Linx+solve_Mix1>0);

fix_DDFact=table2array(T63fix(:,8));
fix_DDFactcomp=table2array(T63fix(:,15));
fix_Linx=table2array(T63fix(:,22));
fix_Mix1=table2array(T63fix(:,29));

fix_DDFact(solve)=63;
fix_DDFactcomp(solve)=63;
fix_Linx(solve)=63;
fix_Mix1(solve)=63;

h63=figure;
h63.Position(3:4)=[1000,400];
p=plot(T63fix{:,"s"},[fix_DDFact,fix_DDFactcomp,fix_Linx,fix_Mix1],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#77AC30';

p(4).LineStyle="--";

xlim([2,62]);
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx","location","northeastoutside");
set(h63,'Units','Inches');
pos = get(h63,'Position');
set(h63,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h63,'./graph/data63_fixnum','-dpdf','-r0');
%=============== Data63 END =======================

%=============== Data90 =======================
T90fix=readtable("./mix_Results/data90fixnum.xlsx");
% data preprocessing
solve_DDFact=table2array(T90fix(:,3));
solve_DDFactcomp=table2array(T90fix(:,10));
solve_Linx=table2array(T90fix(:,17));
solve_Mix1=table2array(T90fix(:,24));
solve=(solve_DDFact+solve_DDFactcomp+solve_Linx+solve_Mix1>0);

fix_DDFact=table2array(T90fix(:,8));
fix_DDFactcomp=table2array(T90fix(:,15));
fix_Linx=table2array(T90fix(:,22));
fix_Mix1=table2array(T90fix(:,29));

fix_DDFact(solve)=90;
fix_DDFactcomp(solve)=90;
fix_Linx(solve)=90;
fix_Mix1(solve)=90;

h90=figure;
h90.Position(3:4)=[1000,400];
p=plot(T90fix{:,"s"},[fix_DDFact,fix_DDFactcomp,fix_Linx,fix_Mix1],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#77AC30';

p(4).LineStyle="--";
xlim([2,89]);
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","mix DDFact\_Linx","location","northeastoutside");
set(h90,'Units','Inches');
pos = get(h90,'Position');
set(h90,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h90,'./graph/data90_fixnum','-dpdf','-r0');
%=============== Data90 END =======================

%=============== Data124 =======================
T124fix=readtable("./mix_Results/data124fixnum.xlsx");
% data preprocessing
solve_DDFact=table2array(T124fix(:,3));
solve_DDFactcomp=table2array(T124fix(:,10));
solve_Linx=table2array(T124fix(:,17));
solve_Mix1=table2array(T124fix(:,24));
solve_Mix2=table2array(T124fix(:,31));
solve_Mix3=table2array(T124fix(:,38));
solve=(solve_DDFact+solve_DDFactcomp+solve_Linx+solve_Mix1+solve_Mix2+solve_Mix3>0);

fix_DDFact=table2array(T124fix(:,8));
fix_DDFactcomp=table2array(T124fix(:,15));
fix_Linx=table2array(T124fix(:,22));
fix_Mix1=table2array(T124fix(:,29));
fix_Mix2=table2array(T124fix(:,36));
fix_Mix3=table2array(T124fix(:,43));

fix_DDFact(solve)=124;
fix_DDFactcomp(solve)=124;
fix_Linx(solve)=124;
fix_Mix1(solve)=124;
fix_Mix2(solve)=124;
fix_Mix3(solve)=124;

h124=figure;
h124.Position(3:4)=[1000,400];
p=plot(T124fix{:,"s"},[fix_DDFact,fix_DDFactcomp,fix_Linx,fix_Mix1,fix_Mix2,fix_Mix3],"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#D95319';
p(3).Color='#EDB120';
p(4).Color='#7E2F8E';
p(5).Color='#77AC30';
p(6).Color='#4DBEEE';

p(4).LineStyle="--";
p(5).LineStyle="--";
p(6).LineStyle="--";
xlim([2,123]);
xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFactcomp","Linx","Mix DDFact\_DDFactcomp","Mix DDFact\_Linx", "Mix DDFactcomp\_Linx",...
    "location","northeastoutside");
set(h124,'Units','Inches');
pos = get(h124,'Position');
set(h124,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h124,'./graph/data124_fixnum','-dpdf','-r0');
%=============== Data124 END =======================

%=============== Data2000 =======================
T2000fix=readtable("./mix_Results/data2000fixnum.xlsx");
% % data preprocessing
% solve_DDFact=table2array(T2000fix(:,3));
% solve_DDFactcomp=table2array(T2000fix(:,10));
% solve_Linx=table2array(T2000fix(:,17));
% solve_Mix1=table2array(T2000fix(:,24));
% solve=(solve_DDFact+solve_DDFactcomp+solve_Linx+solve_Mix1>0);
% 
% fix_DDFact=table2array(T2000fix(:,8));
% fix_DDFactcomp=table2array(T2000fix(:,15));
% fix_Linx=table2array(T2000fix(:,22));
% fix_Mix1=table2array(T2000fix(:,29));
% 
% fix_DDFact(solve)=63;
% fix_DDFactcomp(solve)=63;
% fix_Linx(solve)=63;
% fix_Mix1(solve)=63;

h2000=figure;
h2000.Position(3:4)=[1000,400];
p=plot(T2000fix{:,"s"},T2000fix{:,[6,4]},"LineWidth",1.5);
p(1).Color='#0072BD';
p(2).Color='#0072BD';
p(2).LineStyle='--';
p(2).Marker='*';

xlabel("s");
ylabel("Number of Fixed Variables ");
legend("DDFact", "DDFact\_0","location","northeastoutside");
set(h2000,'Units','Inches');
pos = get(h2000,'Position');
set(h2000,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h2000,'./graph/data2000_fixnum','-dpdf','-r0');
%=============== Data2000 END =======================