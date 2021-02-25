part = "";

module rodNmm(d,length)
{
	color ("#60C0AA")
	    cylinder (d=d,h=length,$fn=40);
}

module rod8mm(length)
{
	rodNmm(d=8,length=length);
}

//rod 7.94, nozzle 0.4 extrusion width 0.41, Cura
//inner7p94=8.10;
inner7p94=8.10+0.05;
razor7p94=[2.2,1,10];

//rod 7.11, nozzle 0.4 extrusion width 0.35, Cura
inner7p11=7.11+0.35;
razor7p11=[1.8,1,10];

//rod 5.0, nozzle 0.4 extrusion width 0.29, Cura
//inner5p0=5.0+0.35;
inner5p0=5.0+0.35+0.1;
razor5p0=[1.6,1,8];

outer=15;
cut=1.2;
groove_parameters=[1.1,14.3];
function lm8_groove_parameters()=groove_parameters;
function lm8luu_groove()=5;
function lm8uu_groove()=3.25;

module lm8_body(height)
{
	union()
	{
		cylinder (d2=outer,d1=outer-cut,h=cut,$fn=80);
		translate ([0,0,cut])
			cylinder (d=outer,h=height-cut*2,$fn=80);
		translate ([0,0,height-cut])
			cylinder (d1=outer,d2=outer-cut,h=cut,$fn=80);
	}
}

module lm8_cut(height,diff)
{
	union()
	{
		translate ([0,0,-height/2])
			cylinder (d=outer+diff*2,h=height,$fn=80);
	}
}

module lm8_inner_cut(inner,height,diff=0)
{
	union()
	{
		translate ([0,0,-0.1])
			cylinder (d2=inner+diff*2,d1=inner+diff*2+cut,h=cut,$fn=80);
		translate ([0,0,height-cut+0.1])
			cylinder (d1=inner+diff*2,d2=inner+diff*2+cut,h=cut,$fn=80);
		cylinder (d=inner+diff*2,h=height,$fn=80);
	}
}

module lm8(inner,razor,height=24.0,groove=3.25)
{
	translate ([0,0,-height/2])
	difference()
	{
		union()
		{
			
			difference()
			{
				lm8_body(height=height);
				lm8_inner_cut(inner=inner,height=height,diff=razor[1]);
			}
			
			difference()
			{
				intersection()
				{
					lm8_body(height=height);
					rays=razor[2];
					angle=360/rays;
					for (a=[0:rays])
						rotate ([0,0,a*angle])
						translate ([-razor[0]/2,0,-0.1])
							cube ([razor[0],outer/2,height+0.2]);
				}
				lm8_inner_cut(inner=inner,height=height);
			}
		}
		for (z=[groove,height-groove-groove_parameters[0]])
		translate ([0,0,z])
		difference()
		{
			cylinder (d=outer+0.2,h=groove_parameters[0],$fn=80);
			translate ([0,0,-0.1])
				cylinder (d=groove_parameters[1],h=groove_parameters[0]+0.2,$fn=80);
		}
	}
}

module lm8luu()
{
	color ("#60C0AA")
		lm8(inner=inner7p94,razor=razor7p94,height=45,groove=lm8luu_groove());
}
module lm8uu(inner)
{
	color ("#60C0AA")
		lm8(inner=inner7p94,razor=razor7p94,height=24,groove=lm8uu_groove());
}
module lm8luu_to_7rod()
{
	color ("#60C0AA")
		lm8(inner=inner7p11,razor=razor7p11,height=45,groove=lm8luu_groove());
}
module lm8uu_to_7rod()
{
	color ("#60C0AA")
		lm8(inner=inner7p11,razor=razor7p11,height=24,groove=lm8uu_groove());
}
module lm8luu_to_5rod()
{
	color ("#60C0AA")
		lm8(inner=inner5p0,razor=razor5p0,height=45,groove=lm8luu_groove());
}
module lm8uu_to_5rod()
{
	color ("#60C0AA")
		lm8(inner=inner5p0,razor=razor5p0,height=24,groove=lm8uu_groove());
}

module proto_lm8luu()
{
	color ("#60C0AA")
	rotate ([0,90,0])
		import ("proto/lm8luu.stl");
}

module proto_lm8uu()
{
	color ("#60C0AA")
	rotate ([90,0,0])
		import ("proto/lm8uu.stl");
}

if (part=="")
{
	lm8luu();
//	lm8uu_to_7rod();
//	lm8uu_to_5rod();
//	lm8luu_to_5rod();
}
if (part=="lm8luu")
{
	lm8luu();
}
if (part=="lm8uu")
{
	lm8uu();
}
if (part=="lm8luu_to_7rod")
{
	lm8luu_to_7rod();
}
if (part=="lm8uu_to_7rod")
{
	lm8uu_to_7rod();
}
if (part=="lm8uu_to_5rod")
{
	lm8uu_to_5rod();
}
if (part=="lm8luu_to_5rod")
{
	lm8luu_to_5rod();
}