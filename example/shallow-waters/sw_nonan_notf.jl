using ShallowWaters, PyPlot

P = run_model(Ndays=100,nx=100,L_ratio=1,bc="nonperiodic",wind_forcing_x="double_gyre",topography="seamount")
pcolormesh(P.η')
savefig("height_nonan_notf.png")

speed = sqrt.(Ix(P.u.^2)[:,2:end-1] + Iy(P.v.^2)[2:end-1,:])
pcolormesh(speed')
savefig("speed_nonan_notf.png")
