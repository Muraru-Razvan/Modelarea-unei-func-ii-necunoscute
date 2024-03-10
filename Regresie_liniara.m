load('proj_fit_30.mat')
%% date Identificare
x1 = id.X{1};
x2 = id.X{2};
y = id.Y;
%% date Validare
x1v = val.X{1};
x2v = val.X{2};
yv = val.Y;
%% 
nrc = 2; % id  pozitia finala la polinom pe coloane
nrcv = 2; % val  pozitia finala la polinom pe coloane
cntc = 2; % id counter resetare coloana
cntvc = 2; % val counter resetare coloana

phi = zeros(length(x1)*length(x2),1);
phi(:,1) = 1;
Iesire = zeros(length(x1)*length(x2),1);
phiv = zeros(length(x1v)*length(x2v),1);
phiv(:,1) = 1;
Iesirev = zeros(length(x1v)*length(x2v),1);

mse_min = 0;
%%
for m = 1:30

cnt = nrc;
p = 0; %counter nr de linii

for i = 1:length(id.X{1})
    for j = 1:length(id.X{2})
        p = p+1;
        cnt = cntc;
        for k = 0:m
            phi(p,cnt) = (x1(i)^k)*(x2(j)^(m-k));
            cnt = cnt+1;
            if i == 1 && j == 1
                nrc = nrc+1;
            end
        end
    end
end
cntc = nrc;

p = 0;
for i = 1:length(id.Y)
    for j = 1:length(id.Y)
        p = p+1;
        Iesire(p,1) = y(j,i);
    end
end

cntv = nrcv;
pv = 0;

for i = 1:length(val.X{1})
    for j = 1:length(val.X{2})
        pv = pv+1;
        cntv = cntvc;    
        for k = 0:m
            phiv(pv,cntv) = (x1v(i)^k)*(x2v(j)^(m-k));
            cntv = cntv+1;
            if i == 1 && j == 1
                nrcv = nrcv+1;
            end
        end
    end
end
cntvc = nrcv;

pv = 0;
for i = 1:length(val.Y)
    for j = 1:length(val.Y)
        pv = pv+1;
        Iesirev(pv,1) = yv(j,i);
    end
end

theta = phi\Iesire;

yhat = phi*theta;
y = reshape(y,[1,41*41]);

yhatv = phiv*theta;
yv = reshape(yv,[1,31*31]);

mse_id(m) = (1/length(id.X{1})*length(id.X{2}))*sum((y'-yhat).^2);
mse_val(m) = (1/length(val.X{1})*length(val.X{2}))*sum((yv'-yhatv).^2);

if m == 1
   mse_min = mse_val(m);
   phi_corect = phi;
   phiv_corect = phiv;
   Iesire_corect = Iesire;
   Iesirev_corect = Iesirev;
end

if m > 1
    if mse_min > mse_val(m)
        m_min = m;
        phi_corect = phi;
        phiv_corect = phiv;
        Iesire_corect = Iesire;
        Iesirev_corect = Iesirev;
        mse_min = mse_val(m);
    end
end

y = reshape(y,[41,41]);
yv = reshape(yv,[31,31]);
end

theta = phi_corect\Iesire_corect;
yhat = phi_corect*theta;
yhatv = phiv_corect*theta;

y = reshape(y,[1,41*41]);
yv = reshape(yv,[1,31*31]);

mse_id_f = (1/length(id.X{1})*length(id.X{2}))*sum((y'-yhat).^2);
mse_val_f = (1/length(val.X{1})*length(val.X{2}))*sum((yv'-yhatv).^2);

y = reshape(y,[41,41]);
yv = reshape(yv,[31,31]);

yhatv = reshape(yhatv,[31,31]);
yhat = reshape(yhat,[41,41]);

figure;
stem(mse_val),title('Eroarea medie patratica minima');

figure;
subplot(211);
mesh(x1,x2,y),xlabel('X1'),ylabel('X2'),zlabel('Y'), title('Y identificare');
subplot(212);
mesh(x1,x2,yhat),xlabel('X1'),ylabel('X2'),zlabel('Y'), title('Y identificare aproximare');

figure;
subplot(211);
mesh(x1v,x2v,yv),xlabel('X1'),ylabel('X2'),zlabel('Y'), title('Y validare');
subplot(212);
mesh(x1v,x2v,yhatv),xlabel('X1'),ylabel('X2'),zlabel('Y'),title('Y validare aproximare');



