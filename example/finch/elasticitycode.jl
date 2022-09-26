#=
Generated functions for elasticity
=#

function lhs_volume_function_for_u(args; kwargs...)
var =       args[1];
eid =       args[2];
fid =       args[3];
grid =      args[4];
geo_facs =  args[5];
refel =     args[6]
time =      args[7];
dt =        args[8]

detj = geo_factors.detJ[eid];     # geometric factors
wdetj = refel.wg .* detj;         # quadrature weights
J = geo_factors.J[eid];           # geometric factors

# Note on derivative matrices:
# RQn are quadrature matrices for the derivatives of the basis functions
# with Jacobian factors. They are made like this.
# |RQ1|   | rx sx tx || Qx |
# |RQ2| = | ry sy ty || Qy |
# |RQ3|   | rz sz tz || Qz |

(RQ1, RQ2, RQ3, RD1, RD2, RD3) = build_deriv_matrix(refel, J);
(TRQ1, TRQ2, TRQ3) = (RQ1', RQ2', RQ3');

value_D1_u_1 = RQ1; # d/dx of trial function
value_D1_v_1 = TRQ1; # d/dx of test function
value_D3_v_3 = TRQ3; # d/dz of test function
value_D1_u_2 = RQ1; # d/dx of trial function
value_D1_v_2 = TRQ1; # d/dx of test function
value_D1_u_3 = RQ1; # d/dx of trial function
value_D1_v_3 = TRQ1; # d/dx of test function
value_D3_v_1 = TRQ3; # d/dz of test function
value_D3_u_3 = RQ3; # d/dz of trial function
value_D3_u_1 = RQ3; # d/dz of trial function
value_D2_u_1 = RQ2; # d/dy of trial function
value_D2_v_1 = TRQ2; # d/dy of test function
value_D2_u_2 = RQ2; # d/dy of trial function
value_D2_v_2 = TRQ2; # d/dy of test function
value_D2_u_3 = RQ2; # d/dy of trial function
value_D2_v_3 = TRQ2; # d/dy of test function
value_D3_v_2 = TRQ3; # d/dz of test function
value_D3_u_2 = RQ3; # d/dz of trial function

element_matrix = zeros(refel.Np * 3, refel.Np * 3); # Allocate the returned matrix.
element_matrix[(0*refel.Np + 1):(1*refel.Np), (0*refel.Np + 1):(1*refel.Np)] = value_D1_v_1 * diagm(wdetj .* 3.25) * value_D1_u_1 .+ value_D2_v_1 * diagm(wdetj) * value_D2_u_1 .+ value_D3_v_1 * diagm(wdetj) * value_D3_u_1
element_matrix[(0*refel.Np + 1):(1*refel.Np), (1*refel.Np + 1):(2*refel.Np)] = value_D1_v_1 * diagm(wdetj .* 1.25) * value_D2_u_2 .+ value_D2_v_1 * diagm(wdetj) * value_D1_u_2
element_matrix[(0*refel.Np + 1):(1*refel.Np), (2*refel.Np + 1):(3*refel.Np)] = value_D3_v_1 * diagm(wdetj) * value_D1_u_3 .+ value_D1_v_1 * diagm(wdetj .* 1.25) * value_D3_u_3
element_matrix[(1*refel.Np + 1):(2*refel.Np), (0*refel.Np + 1):(1*refel.Np)] = value_D1_v_2 * diagm(wdetj) * value_D2_u_1 .+ value_D2_v_2 * diagm(wdetj .* 1.25) * value_D1_u_1
element_matrix[(1*refel.Np + 1):(2*refel.Np), (1*refel.Np + 1):(2*refel.Np)] = value_D1_v_2 * diagm(wdetj) * value_D1_u_2 .+ value_D2_v_2 * diagm(wdetj .* 3.25) * value_D2_u_2 .+ value_D3_v_2 * diagm(wdetj) * value_D3_u_2
element_matrix[(1*refel.Np + 1):(2*refel.Np), (2*refel.Np + 1):(3*refel.Np)] = value_D3_v_2 * diagm(wdetj) * value_D2_u_3 .+ value_D2_v_2 * diagm(wdetj .* 1.25) * value_D3_u_3
element_matrix[(2*refel.Np + 1):(3*refel.Np), (0*refel.Np + 1):(1*refel.Np)] = value_D3_v_3 * diagm(wdetj .* 1.25) * value_D1_u_1 .+ value_D1_v_3 * diagm(wdetj) * value_D3_u_1
element_matrix[(2*refel.Np + 1):(3*refel.Np), (1*refel.Np + 1):(2*refel.Np)] = value_D3_v_3 * diagm(wdetj .* 1.25) * value_D2_u_2 .+ value_D2_v_3 * diagm(wdetj) * value_D3_u_2
element_matrix[(2*refel.Np + 1):(3*refel.Np), (2*refel.Np + 1):(3*refel.Np)] = value_D1_v_3 * diagm(wdetj) * value_D1_u_3 .+ value_D2_v_3 * diagm(wdetj) * value_D2_u_3 .+ value_D3_v_3 * diagm(wdetj .* 3.25) * value_D3_u_3
return element_matrix;

end #lhs_volume_function_for_u

# No lhs surface set for u

function rhs_volume_function_for_u(args; kwargs...)
var =       args[1];
eid =       args[2];
fid =       args[3];
grid =      args[4];
geo_facs =  args[5];
refel =     args[6]
time =      args[7];
dt =        args[8]

detj = geo_factors.detJ[eid];     # geometric factors
wdetj = refel.wg .* detj;         # quadrature weights

value__v_1 = refel.Q'; # test function.
value__f_1 = 0;
value__v_2 = refel.Q'; # test function.
value__f_2 = 0;
value__v_3 = refel.Q'; # test function.
value__f_3 = -10;

element_vector = zeros(refel.Np * 3); # Allocate the returned vector.
element_vector[(0*refel.Np + 1):(1*refel.Np)] = value__v_1 * (wdetj .* value__f_1)
element_vector[(1*refel.Np + 1):(2*refel.Np)] = value__v_2 * (wdetj .* value__f_2)
element_vector[(2*refel.Np + 1):(3*refel.Np)] = value__v_3 * (wdetj .* value__f_3)
return element_vector;

end #rhs_volume_function_for_u

# No rhs surface set for u

# No assembly function set for u

