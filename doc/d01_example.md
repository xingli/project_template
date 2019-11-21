# Starting up -- 11/21/2019

11/21/2019

Contents using markdown...

This is maths

\\[ x^2 + y^2 = z^2 \\]

and inline math with \\( \alpha \\)

This is an example of regression table

	DV: log(share) - log(share0)
	------------------------------------------------------------------
				  (1)        (2)        (3)        (4)
	------------------------------------------------------------------
	Ln(Ads)                  0.060**    0.055**    0.048*     0.046*
				(0.024)    (0.024)    (0.026)    (0.026)
	Unemploy                -0.054***  -0.059***  -0.056***  -0.060***
				(0.011)    (0.010)    (0.011)    (0.010)
	Income                   0.008***   0.007***   0.008***   0.007***
				(0.002)    (0.001)    (0.002)    (0.001)
	Unemp-contiguous                    0.019                 0.014
				(0.012)               (0.013)
	Inc-contiguous                      0.007                 0.007
					   (0.005)               (0.005)
	Unemp-largest                                  0.035***   0.031**
							(0.011)    (0.013)
	Inc-largest                                   -0.005     -0.005
						       (0.005)    (0.005)
	Waldfogel IV               Yes        Yes        Yes        Yes
	------------------------------------------------------------------
	Observations              6428       6428       6428       6428
	R-squared                0.629      0.631      0.630      0.632
	First-stage excluded F  48.742     48.477     16.721     16.833
	First-stage partial R2   0.484      0.482      0.445      0.445
	------------------------------------------------------------------
	Clustered SE at Party-dma, unit of obs: party-county-year
	Other controls, party-year FE, party-DMA FE are included.

And this is plot

![img](./fig/f02_MkscBordComp.png)

