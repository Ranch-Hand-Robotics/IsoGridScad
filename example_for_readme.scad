// Example file for generating README screenshots
// Uncomment the example you want to render

use <isogrid.scad>
include <BOSL2/std.scad>

// Helper for polygons
function regular_polygon(sides, radius) =
    [for (i = [0:sides-1]) [radius * cos(i * 360 / sides), radius * sin(i * 360 / sides)]];

// =============================================================================
// EXAMPLE 1: Basic Rectangular Isogrid
// =============================================================================
//isogrid_rect(200, 150, triangle_size=20, thickness=1, extrude=1);

// =============================================================================
// EXAMPLE 2: 3D Extruded Rectangular Isogrid
// =============================================================================
//isogrid_rect(200, 150, triangle_size=20, thickness=1, extrude=3);

// =============================================================================
// EXAMPLE 3: Hexagonal Polygon Isogrid
// =============================================================================
//isogrid_polygon(regular_polygon(6, 80), triangle_size=15, thickness=1, extrude=1);

// =============================================================================
// EXAMPLE 4: Pentagon Isogrid
// =============================================================================
//isogrid_polygon(regular_polygon(5, 80), triangle_size=15, thickness=1, extrude=1);

// =============================================================================
// EXAMPLE 5: Star Shape Isogrid
// =============================================================================
/*
points = 6; outer_r = 80; inner_r = 40;
star = [for (i=[0:2*points-1]) 
    let(r=(i%2==0)?outer_r:inner_r, ang=i*180/points) 
    [r*cos(ang), r*sin(ang)]];
isogrid_polygon(star, triangle_size=12, thickness=1, extrude=1);
*/

// =============================================================================
// EXAMPLE 6: Thickness Comparison (shows 0.5, 1.0, 1.5, 2.0mm)
// =============================================================================
for(i=[0:3]) {
    translate([i*70-105, 30]) 
        isogrid_rect(60, 60, triangle_size=12, thickness=0.5+i*0.5, extrude=1);
    translate([i*70-105, -40]) 
        isogrid_polygon(regular_polygon(6,30), triangle_size=12, thickness=0.5+i*0.5, extrude=1);
}

// =============================================================================
// EXAMPLE 7: Density Comparison (fine vs coarse)
// =============================================================================
/*
translate([-80, 0]) 
    isogrid_rect(120, 100, triangle_size=8, thickness=0.6, extrude=1);
translate([80, 0]) 
    isogrid_rect(120, 100, triangle_size=25, thickness=1.5, extrude=1);
*/

// =============================================================================
// EXAMPLE 8: Attached to 3D Object (BOSL2)
// =============================================================================
//cuboid([200,150,12], anchor=CENTER) 
//    attach(TOP) 
//        isogrid_rect(200, 150, triangle_size=20, thickness=1.5, extrude=1);

// =============================================================================
// EXAMPLE 9: Hexagonal Cylinder with Isogrid Top
// =============================================================================
/*
cyl(h=12, d=160, anchor=CENTER, $fn=6)
    attach(TOP)
        isogrid_polygon(regular_polygon(6, 80), triangle_size=15, thickness=1.5, extrude=1);
*/

// =============================================================================
// EXAMPLE 10: Multiple Polygon Shapes Side by Side
// =============================================================================
translate([-120, 0]) 
    isogrid_polygon(regular_polygon(3, 60), triangle_size=12, thickness=1, extrude=1);
translate([0, 0]) 
    isogrid_polygon(regular_polygon(6, 60), triangle_size=12, thickness=1, extrude=1);
translate([120, 0]) 
    isogrid_polygon(regular_polygon(8, 60), triangle_size=12, thickness=1, extrude=1);
