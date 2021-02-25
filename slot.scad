// constants
vslot = 20;
vslot_groove = 1.0;//1.8
vslot_groove_outer = 9.00;
vslot_groove_inner = 6.99;

module groove(width, max_height=0)
{
    offset = (vslot_groove_outer - vslot_groove_inner) / 2;
	groove_points = [[0,0], [0,vslot_groove_outer], [-vslot_groove,vslot_groove_outer-offset], [-vslot_groove,offset]];
	
	difference()
	{
		translate([0,-vslot_groove_outer/2,0])
		linear_extrude(height = width)
			polygon (points=groove_points);
	
		if (max_height > 0)
		{
			yy=vslot_groove_outer+2;
			translate ([-vslot_groove-max_height,-yy/2,-1])
				cube([vslot_groove,yy,width+2]);
		}
	}
}

function groove_thickness() = vslot_groove;

//groove(20);
groove(20,max_height=0.5);