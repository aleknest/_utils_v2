function m3_cap_diameter() = 6.0; 
function m3_cap_h() = 3;
function m3_nut_G() = 6.6;
function m3_nut_G_inner_diff()=0.2;
function m3_nut_h() = 2.4 + 0.2;
function m3_screw_diameter() = 3.4; //M3 screw + diff (prev 0.4)
function m3_washer_diameter_diff() = 1;
function m3_washer_diameter() = 7 + m3_washer_diameter_diff(); // M3 washer diameter 7mm + diff
function m3_washer_thickness() = 0.5;
function m3_square_nut_S_real()=5.5;
function m3_square_nut_S()=m3_square_nut_S_real()+0.2;
function m3_square_nut_H()=1.8+0.2;

function m5_cap_h() = 4.82+0.18;
function m5_cap_diameter() = 9;
function m5_screw_diameter_diff() = 1;
function m5_screw_diameter() = 5 + m5_screw_diameter_diff();
function m5_washer_diameter_diff() = 0.2+0.2;//24.1.2021
function m5_washer_diameter() = 10 + m5_washer_diameter_diff();
function m5_washer_height() = 1;
function m5_nut_G() = 9;
function m5_nut_S() = 7.95+0.3; //orig 7.95
function m5_nut_H() = 4.49 + 0.2;

function m6_cap_h() = 5.7+0.2;
function m6_screw_diameter_diff() = 1;
function m6_screw_diameter() = 6 + m6_screw_diameter_diff();
function m6_washer_diameter_diff() = 0.2+0.2;
function m6_washer_diameter() = 12 + m6_washer_diameter_diff();
function m6_washer_height() = 1.5;

function m8_nut_G() = 14.38+1;
function m8_nut_H() = 6.8+0.2;

function m2p5_nut_G() = 5.45+0.2;
function m2p5_nut_H() = 2+0.2;

module m3_screw(h,cap_out=m3_cap_h(),cap_side_out=0)
{
	translate ([0,0,-0.1])
		cylinder (d=m3_screw_diameter(),h=h+0.1,$fn=20);
	translate ([0,0,-cap_out])
	hull()
	{
		cylinder (d=m3_cap_diameter(),h=cap_out,$fn=30);
		translate ([cap_side_out,0,0])
			cylinder (d=m3_cap_diameter(),h=cap_out,$fn=30);
	}
}
module m3_screw_add()
{
	translate ([0,0,0])
		cylinder (d=m3_cap_diameter()+0.1,h=0.4,$fn=30);
}
module m3_washer(out=10,offs=0,sphere=false)
{
	fn=60;
	translate ([0,0,-out+m3_washer_thickness()])
	{
		dd=m3_washer_diameter()+offs*2;
		cylinder (d=dd,h=out,$fn=fn);
		if (sphere)
			sphere (d=dd,$fn=fn);
	}
}
module m3_washer_add(out=10)
{
	translate ([0,0,-out+m3_washer_thickness()+out])
		cylinder (d=m3_washer_diameter()+0.1,h=0.4,$fn=30);
}
module m3_square_nut(out=20,offs=0.2,short_fix=false)
{
	square=m3_square_nut_S()+offs;
	translate ([-square/2,-square/2,0])
	{
		cube ([square,square+out,m3_square_nut_H()],false);
		diff=0.2;
		in=short_fix?2:0;
		translate ([-diff,square-0.2-in,-diff])
			cube ([square+diff*2,0.2+out,m3_square_nut_H()+diff*2],false);
	}
}
module m3_square_nut_planar(out=20)
{
	hh=m3_square_nut_H();
	translate ([-m3_square_nut_S_real()/2,-m3_square_nut_S_real()/2,0])
		cube ([m3_square_nut_S_real(),m3_square_nut_S_real(),hh],false);	
	translate ([-m3_square_nut_S()/2,-m3_square_nut_S()/2,hh-0.01])
		cube ([m3_square_nut_S(),m3_square_nut_S(),out],false);
}

module nut(G=undef,H,S=undef)
{
    // G,e
	// S,F
    //R = 0.5; A = 0; x = cos(A) * R; y = sin(A) * R;
	
	gg=str(S) != "undef" ? S/cos(30) : G;
	
    nut_points=[
	 [0.5,0]
	,[0.25,0.433013]
	,[-0.25,0.433013]
	,[-0.5,0]
	,[-0.25,-0.433013]
	,[0.25,-0.433013]
    ];

    scale ([gg,gg,1])
    linear_extrude(H)
	polygon (points=nut_points);
}

module m3_nut(h=m3_nut_h())
{
	nut(G=m3_nut_G(),H=h);
}

module m3_nut_inner(h=m3_nut_h(),diff=0)
{
	nut(G=m3_nut_G()-m3_nut_G_inner_diff()-diff,H=h);
}

module m5_screw(h,cap_out=m5_cap_h())
{
	translate ([0,0,-0.1])
		cylinder (d=m5_screw_diameter(),h=h+0.1,$fn=20);
	translate ([0,0,-cap_out])
		cylinder (d=m5_cap_diameter(),h=cap_out,$fn=30);
}

module mn_screw_washer(screw_diameter
					,washer_diameter
					,washer_height
					,thickness
					,diff=0.1
					,washer_out=0
					,washer_side_out=0
					,washer_side_out_add=0
					,washer_spere=false
					,tnut=false
)
{
	tnut_dim=[12,14,diff];
	translate ([0,0,-diff])
	{
		cylinder (d=screw_diameter, h=thickness+diff*2,$fn=40);
		if (tnut)
			translate ([-tnut_dim.x/2,-tnut_dim.y/2,thickness+diff])
				cube (tnut_dim);
			
		translate ([0,0,-washer_out])
		{
			cylinder (d=washer_diameter, h=washer_height/2+diff+washer_out,$fn=40);
			if (washer_spere)
				sphere (d=washer_diameter, $fn=40);
			if (washer_side_out>0)
			{
				hull()
				{
					cylinder (d=washer_diameter, h=washer_out,$fn=40);
					if (washer_spere)
						sphere (d=washer_diameter, $fn=40);
					translate ([washer_side_out,0,0])
					{
						cylinder (d=washer_diameter+washer_side_out_add, h=washer_out,$fn=40);
						if (washer_spere)
							sphere (d=washer_diameter, $fn=40);
					}
				}
			}
		}
	}
}

module m5n_screw_washer(thickness
						,diff=0.1
						,washer_out=0
						,washer_side_out=0
						,washer_side_out_add=0
						,washer_spere=false
						,tnut=false
						,cap_only=false
)
{
	mn_screw_washer(screw_diameter=m5_screw_diameter()
					,washer_diameter=cap_only?m5_cap_diameter():m5_washer_diameter()
					,washer_height=m5_washer_height()
					,thickness=thickness
					,diff=diff
					,washer_out=washer_out
					,washer_side_out=washer_side_out
					,washer_side_out_add=washer_side_out_add
					,washer_spere=washer_spere
					,tnut=tnut
	);
}

module m6n_screw_washer(thickness, diff=0.1, washer_out=0,washer_side_out=0,washer_side_out_add=0,washer_spere=false)
{
	mn_screw_washer(screw_diameter=m6_screw_diameter()
					,washer_diameter=m6_washer_diameter()
					,washer_height=m6_washer_height()
					,thickness=thickness
					,diff=diff
					,washer_out=washer_out
					,washer_side_out=washer_side_out
					,washer_side_out_add=washer_side_out_add
					,washer_spere=washer_spere);
}

module m5n_screw_washer_add()
{
	translate ([0,0,m5_washer_height()/2])
	{
		cylinder (d=m5_washer_diameter()+0.2, h=0.3,$fn=40);
	}
}

