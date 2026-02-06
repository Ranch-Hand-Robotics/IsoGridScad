// =============================================================================
// IsoGridScad - Isogrid Pattern Generation Library
// =============================================================================
// Copyright (c) 2025 Ranch Hand Robotics, LLC
// Licensed under the MIT License - See LICENSE.txt for details
// 
// Generates isometric grid patterns for rectangles and polygons
// Uses standard OpenSCAD geometry only (no BOSL2 dependencies)
// =============================================================================

// ============================================================================
// 2D ISOGRID PATTERN GENERATORS
// ============================================================================

/**
 * Generate an isogrid pattern within a rectangle (2D or 3D)
 * 
 * Parameters:
 *   width: Width of the rectangle
 *   height: Height of the rectangle
 *   triangle_size: Size of individual triangles in the grid
 *   thickness: Thickness of the grid lines
 *   extrude: Height to extrude (0 for 2D)
 * 
 * Example:
 *   isogrid_rect(200, 150, triangle_size=20);
 *   isogrid_rect(200, 150, triangle_size=20, extrude=10);
 */
module isogrid_rect(width, height, triangle_size = 10, thickness = 1, extrude = 0) {
    // For equilateral triangles: perpendicular spacing between any set of parallel lines
    h = triangle_size * sqrt(3) / 2;
    
    // Calculate how many lines we need to cover the area
    rows_horiz = ceil(height / h) + 2;
    rows_60 = ceil((height + width * sqrt(3)) / (2 * h)) + 2;
    rows_120 = rows_60;

    module _isogrid_rect_2d() {
        // Create union of three sets of parallel line strokes
        union() {
            // Horizontal lines (0°): y = n * h
            for (i = [-rows_horiz : rows_horiz]) {
                translate([0, i * h])
                    square([width + 2*triangle_size, thickness], center=true);
            }

            // Lines at 60° from horizontal
            for (i = [-rows_60 : rows_60]) {
                rotate(60)
                    translate([0, i * h])
                        square([sqrt(width*width + height*height) + 2*triangle_size, thickness], center=true);
            }

            // Lines at -60° from horizontal
            for (i = [-rows_120 : rows_120]) {
                rotate(-60)
                    translate([0, i * h])
                        square([sqrt(width*width + height*height) + 2*triangle_size, thickness], center=true);
            }
        }
    }

    // Render clipped to rectangle boundary, creating solid filled geometry
    if (extrude > 0) {
        linear_extrude(height=extrude, center=true) {
            intersection() {
                square([width, height], center=true);
                _isogrid_rect_2d();
            }
        }
    } else {
        intersection() {
            square([width, height], center=true);
            _isogrid_rect_2d();
        }
    }
}

/**
 * Generate an isogrid pattern within a polygon
 * 
 * Parameters:
 *   polygon: List of [x, y] points defining the polygon boundary
 *   triangle_size: Size of individual triangles in the grid
 *   thickness: Thickness of the grid lines
 *   extrude: Height to extrude (0 for 2D)
 * 
 * Note: The pattern is clipped to the polygon boundary
 * 
 * Example:
 *   hex = [for (i = [0:5]) [50*cos(i*60), 50*sin(i*60)]];
 *   isogrid_polygon(hex, triangle_size=15);
 */
module isogrid_polygon(polygon, triangle_size = 10, thickness = 1, extrude = 0) {
    // Get polygon bounding box for sizing
    xs = [for (p = polygon) p[0]];
    ys = [for (p = polygon) p[1]];
    min_x = min(xs);
    max_x = max(xs);
    min_y = min(ys);
    max_y = max(ys);

    width = max_x - min_x;
    height = max_y - min_y;

    // Center of polygon bounding box
    cx = (min_x + max_x) / 2;
    cy = (min_y + max_y) / 2;

    // For equilateral triangles: perpendicular spacing between any set of parallel lines
    h = triangle_size * sqrt(3) / 2;
    
    // Calculate how many lines we need to cover the area
    rows_horiz = ceil(height / h) + 2;
    rows_60 = ceil((height + width * sqrt(3)) / (2 * h)) + 2;
    rows_120 = rows_60;

    module _isogrid_poly_2d() {
        union() {
            // Horizontal lines (0°): y = n * h
            for (i = [-rows_horiz : rows_horiz]) {
                translate([0, i * h])
                    square([width + 2*triangle_size, thickness], center=true);
            }

            // Lines at 60° from horizontal
            for (i = [-rows_60 : rows_60]) {
                rotate(60)
                    translate([0, i * h])
                        square([sqrt(width*width + height*height) + 2*triangle_size, thickness], center=true);
            }

            // Lines at -60° from horizontal
            for (i = [-rows_120 : rows_120]) {
                rotate(-60)
                    translate([0, i * h])
                        square([sqrt(width*width + height*height) + 2*triangle_size, thickness], center=true);
            }
        }
    }

    // Render clipped to polygon boundary
    if (extrude > 0) {
        linear_extrude(height=extrude, center=true) {
            intersection() {
                polygon(polygon);
                translate([cx, cy]) _isogrid_poly_2d();
            }
        }
    } else {
        intersection() {
            polygon(polygon);
            translate([cx, cy]) _isogrid_poly_2d();
        }
    }
}

