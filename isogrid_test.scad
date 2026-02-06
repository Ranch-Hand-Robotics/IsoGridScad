// isogrid_test.scad - consolidated test suite for isogrid library
// Renders all tests at once in a laid-out grid

include <BOSL2/std.scad>
use <isogrid.scad>

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------
function regular_polygon(sides, radius) =
    [for (i = [0:sides-1]) [radius * cos(i * 360 / sides), radius * sin(i * 360 / sides)]];

// -----------------------------------------------------------------------------
// Rectangular isogrid tests
// -----------------------------------------------------------------------------
module test_rect_basic()               isogrid_rect(200, 150, triangle_size=20, thickness=1, extrude=1);
module test_rect_fine_detail()         isogrid_rect(200, 150, triangle_size=10, thickness=0.8, extrude=1);
module test_rect_thick_lines()         isogrid_rect(200, 150, triangle_size=20, thickness=2, extrude=1);
module test_rect_wide()                isogrid_rect(300, 100, triangle_size=20, thickness=1, extrude=1);
module test_rect_square()              isogrid_rect(150, 150, triangle_size=15, thickness=1, extrude=1);
module test_rect_cyberdeck()           isogrid_rect(400, 200, triangle_size=15, thickness=1, extrude=1);
module test_rect_attach_top()          cuboid([200,150,12], anchor=CENTER) attach(TOP)    isogrid_rect(200,150, triangle_size=20, thickness=1.5, extrude=1);
module test_rect_attach_bottom()       cuboid([200,150,12], anchor=CENTER) attach(BOTTOM) isogrid_rect(200,150, triangle_size=20, thickness=1.5, extrude=1);
module test_rect_attach_spin()         cuboid([200,150,12], anchor=CENTER) attach(TOP, spin=90) isogrid_rect(200,150, triangle_size=20, thickness=1.5, extrude=1);

// -----------------------------------------------------------------------------
// Polygonal isogrid tests
// -----------------------------------------------------------------------------
module test_poly_hex()                 isogrid_polygon(regular_polygon(6, 80),  triangle_size=15, thickness=1, extrude=1);
module test_poly_pentagon()            isogrid_polygon(regular_polygon(5, 80),  triangle_size=15, thickness=1, extrude=1);
module test_poly_octagon()             isogrid_polygon(regular_polygon(8, 80),  triangle_size=15, thickness=1, extrude=1);
module test_poly_triangle()            isogrid_polygon(regular_polygon(3, 80),  triangle_size=15, thickness=1, extrude=1);
module test_poly_small_triangles()     isogrid_polygon(regular_polygon(6, 80),  triangle_size=10, thickness=1, extrude=1);
module test_poly_large_triangles()     isogrid_polygon(regular_polygon(6, 80),  triangle_size=25, thickness=1, extrude=1);
module test_poly_thick()               isogrid_polygon(regular_polygon(6, 80),  triangle_size=15, thickness=2, extrude=1);
module test_poly_large_hex()           isogrid_polygon(regular_polygon(6,120),  triangle_size=20, thickness=1, extrude=1);
module test_poly_irregular()           isogrid_polygon([[0,0],[100,20],[120,80],[80,120],[20,100],[-20,40]], triangle_size=15, thickness=1, extrude=1);
module test_poly_star() {
    points = 6; outer_r = 80; inner_r = 40;
    poly = [for (i=[0:2*points-1]) let(r=(i%2==0)?outer_r:inner_r, ang=i*180/points) [r*cos(ang), r*sin(ang)]];
    isogrid_polygon(poly, triangle_size=12, thickness=1, extrude=1);
}
module test_poly_attach_top() {
    poly = regular_polygon(6, 80);
    cyl(h=12, d=160, anchor=CENTER, $fn=6)
        attach(TOP)
            isogrid_polygon(poly, triangle_size=15, thickness=1.5, extrude=1);
}
module test_poly_attach_bottom() {
    poly = regular_polygon(6, 80);
    cyl(h=12, d=160, anchor=CENTER, $fn=6)
        attach(BOTTOM)
            isogrid_polygon(poly, triangle_size=15, thickness=1.5, extrude=1);
}
module test_poly_attach_spin() {
    poly = regular_polygon(6, 80);
    cyl(h=12, d=160, anchor=CENTER, $fn=6)
        attach(TOP, spin=60)
            isogrid_polygon(poly, triangle_size=15, thickness=1.5, extrude=1);
}

// -----------------------------------------------------------------------------
// Integration / comparison tests
// -----------------------------------------------------------------------------
module test_side_by_side_2d() {
    translate([-110,0]) isogrid_rect(180,120, triangle_size=15, thickness=1, extrude=1);
    translate([ 110,0]) isogrid_polygon(regular_polygon(6,60), triangle_size=15, thickness=1, extrude=1);
}
module test_3d_attached_duo() {
    translate([-110,0,0]) cuboid([180,120,12], anchor=CENTER) attach(TOP) isogrid_rect(180,120, triangle_size=15, thickness=1.5, extrude=1);
    translate([ 110,0,0]) cyl(h=12, d=120, anchor=CENTER, $fn=6) attach(TOP) isogrid_polygon(regular_polygon(6,60), triangle_size=15, thickness=1.5, extrude=1);
}
module test_thickness_variation() {
    th=[0.5,1,1.5,2];
    for(i=[0:3]) translate([i*70-105,0]) isogrid_rect(60,60, triangle_size=12, thickness=th[i], extrude=1);
    for(i=[0:3]) translate([i*70-105,-80]) isogrid_polygon(regular_polygon(6,30), triangle_size=12, thickness=th[i], extrude=1);
}
module test_density_variation() {
    translate([-110, 0]) isogrid_rect(150,120, triangle_size=5,  thickness=0.5, extrude=1);
    translate([ 110, 0]) isogrid_rect(150,120, triangle_size=30, thickness=1.5, extrude=1);
    translate([-110,-120]) isogrid_polygon(regular_polygon(6,50), triangle_size=5,  thickness=0.5, extrude=1);
    translate([ 110,-120]) isogrid_polygon(regular_polygon(6,50), triangle_size=30, thickness=1.5, extrude=1);
}
module test_scale_progression() {
    scales=[0.5,0.75,1.0,1.25,1.5]; base=60;
    for(i=[0:4]) translate([i*90-180, 50]) isogrid_rect(base*scales[i], base*0.75*scales[i], triangle_size=12, thickness=0.8, extrude=1);
    for(i=[0:4]) translate([i*90-180,-50]) isogrid_polygon(regular_polygon(6, base/3*scales[i]), triangle_size=12, thickness=0.8, extrude=1);
}

// -----------------------------------------------------------------------------
// Layout: render everything at once
// -----------------------------------------------------------------------------
module render_all_tests() {
    step_x = 260; step_y = 200;
    // Row 1 - basic rectangles
    translate([-step_x,  step_y, 0]) test_rect_basic();
    translate([   0   ,  step_y, 0]) test_rect_fine_detail();
    translate([ step_x,  step_y, 0]) test_rect_thick_lines();
    // Row 2 - more rectangles / attachments
    translate([-step_x, 0, 0]) test_rect_wide();
    translate([   0   , 0, 0]) test_rect_square();
    translate([ step_x, 0, 0]) test_rect_attach_top();
    // Row 3 - polygons
    translate([-step_x, -step_y, 0]) test_poly_hex();
    translate([   0   , -step_y, 0]) test_poly_pentagon();
    translate([ step_x, -step_y, 0]) test_poly_irregular();
    // Row 4 - polygon variations / attachments
    translate([-step_x, -2*step_y, 0]) test_poly_small_triangles();
    translate([   0   , -2*step_y, 0]) test_poly_large_triangles();
    translate([ step_x, -2*step_y, 0]) test_poly_attach_top();
    // Row 5 - comparisons and advanced
    translate([-step_x, -3*step_y, 0]) test_side_by_side_2d();
    translate([   0   , -3*step_y, 0]) test_3d_attached_duo();
    translate([ step_x, -3*step_y, 0]) test_thickness_variation();
    // Row 6 - density / scale
    translate([-step_x, -4*step_y, 0]) test_density_variation();
    translate([   0   , -4*step_y, 0]) test_scale_progression();
    translate([ step_x, -4*step_y, 0]) test_poly_attach_spin();
}

// Default render
render_all_tests();
