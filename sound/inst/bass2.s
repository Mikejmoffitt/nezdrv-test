	opnp_con_fb  0,  7
	opnp_mul_dt  5, -3  ; op 1
	opnp_mul_dt  1, -3  ; op 3
	opnp_mul_dt  2,  1  ; op 2
	opnp_mul_dt  1,  1  ; op 4
	opnp_tl     25      ; op 1
	opnp_tl     30      ; op 3
	opnp_tl     26      ; op 2
	opnp_tl     16      ; op 4
	opnp_ar_ks  31,  3  ; op 1
	opnp_ar_ks  31,  0  ; op 3
	opnp_ar_ks  31,  1  ; op 2
	opnp_ar_ks  31,  0  ; op 4
	opnp_dr_am   9,  0  ; op 1
	opnp_dr_am   1,  0  ; op 3
	opnp_dr_am  10,  0  ; op 2
	opnp_dr_am   1,  0  ; op 4
	opnp_sr      0      ; op 1
	opnp_sr      0      ; op 3
	opnp_sr      0      ; op 2
	opnp_sr      0      ; op 4
	opnp_rr_sl  15, 15  ; op 1
	opnp_rr_sl  15, 15  ; op 3
	opnp_rr_sl  15, 15  ; op 2
	opnp_rr_sl  15, 15  ; op 4
	opnp_ssg_eg  0      ; op 1
	opnp_ssg_eg  0      ; op 3
	opnp_ssg_eg  0      ; op 2
	opnp_ssg_eg  0      ; op 4
