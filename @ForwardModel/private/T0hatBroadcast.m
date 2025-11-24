function T0hat = T0hatBroadcast(T0hat_fh,Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,sx,sy,P,f0,u,v)
arguments
    T0hat_fh (1,1) function_handle
    Kf11 (1,1,:,:,1) double
    Kf12 (1,1,:,:,1) double
    Kf13 (1,1,:,:,1) double
    Kf22 (1,1,:,:,1) double
    Kf23 (1,1,:,:,1) double
    Kf33 (1,1,:,:,1) double
    Cf   (1,1,:,:,1) double
    af   (1,1,:,:,1) double
    Rf   (1,1,:,:,1) double
    hf   (1,1,:,:,1) double
    Ks11 (1,1,:,:,1) double
    Ks12 (1,1,:,:,1) double
    Ks13 (1,1,:,:,1) double
    Ks22 (1,1,:,:,1) double
    Ks23 (1,1,:,:,1) double
    Ks33 (1,1,:,:,1) double
    Cs   (1,1,:,:,1) double
    as   (1,1,:,:,1) double
    Rs   (1,1,:,:,1) double
    hs   (1,1,:,:,1) double
    Rth  (1,1,:,:,1) double
    sx   (1,1,1,1,1) double
    sy   (1,1,1,1,1) double
    P    (1,1,1,1,1) double
    f0   (1,1,1,1,:) double
    u    (:,1,1,1,1) double
    v    (1,:,1,1,1) double
end
T0hat = T0hat_fh(Kf11,Kf12,Kf13,Kf22,Kf23,Kf33,Cf,af,Rf,hf,Ks11,Ks12,Ks13,Ks22,Ks23,Ks33,Cs,as,Rs,hs,Rth,sx,sy,P,f0,u,v);