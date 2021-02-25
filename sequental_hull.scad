module sequental_hull()
{
    union()
    {
        for (i=[0:$children-2])
        {
            hull()
            {
                children(i);
                children(i+1);
            }
        }
    }
}

module hullout(dim)
{
	for (i=[0:$children-1] ) 
	{
		hull()
		{
			children(i);
			translate (dim)
				children(i);
		}
	}
}

module test()
{
    sequental_hull()
    {
        cube ([10,10,10],true);
        translate ([30,0,0])
            sphere (10);
        translate ([60,0,30])
        scale ([1,6,1])
            sphere (5);
    }
}

test();