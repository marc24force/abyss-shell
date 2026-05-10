#!/usr/bin/env python3
import sys
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.boundsPen import BoundsPen
from scour import scour

FONT_PATH = "/usr/share/fonts/NerdFonts/ttf/symbols/SymbolsNerdFontMono-Regular.ttf"
TARGET_SIZE = 128

def extract_glyph_svg(codepoint_hex, output_file):
    font = TTFont(FONT_PATH)
    glyph_set = font.getGlyphSet()

    codepoint = int(codepoint_hex, 16)
    cmap = font.getBestCmap()
    if codepoint not in cmap:
        print(f"Codepoint {codepoint_hex} not found.")
        return

    glyph_name = cmap[codepoint]
    glyph = glyph_set[glyph_name]

    # Bounding box
    bounds_pen = BoundsPen(glyph_set)
    glyph.draw(bounds_pen)
    bb = bounds_pen.bounds or (0, 0, 1024, 1024)
    xMin, yMin, xMax, yMax = bb
    width = xMax - xMin
    height = yMax - yMin

    scale = TARGET_SIZE / max(width, height)
    scaled_width = width * scale
    scaled_height = height * scale

    # Centrat dins del canvas
    dx = (TARGET_SIZE - scaled_width) / 2 - xMin * scale
    dy = (TARGET_SIZE - scaled_height) / 2 - yMin * scale

    # Centre vertical per fer flip
    glyph_center_y = (yMax + yMin) / 2

    class FlipCenteredPen(SVGPathPen):
        def _round(self, p):
            return tuple(round(v) for v in p)
        def _transform_point(self, p):
            # Flip vertical respecte al centre del glyph
            y_flipped = 2*glyph_center_y - p[1]
            x = p[0]*scale + dx
            y = y_flipped*scale + dy
            return self._round((x, y))
        def _moveTo(self, p):
            super()._moveTo(self._transform_point(p))
        def _lineTo(self, p):
            super()._lineTo(self._transform_point(p))
        def _qCurveToOne(self, p1, p2):
            super()._qCurveToOne(self._transform_point(p1), self._transform_point(p2))
        def _curveToOne(self, p1, p2, p3):
            super()._curveToOne(self._transform_point(p1), self._transform_point(p2), self._transform_point(p3))

    pen = FlipCenteredPen(glyph_set)
    glyph.draw(pen)
    svg_path = pen.getCommands()

    # SVG mínim amb fill
    raw_svg = f'<svg viewBox="0 0 {TARGET_SIZE} {TARGET_SIZE}"><path fill="#FFF" d="{svg_path}"/></svg>'

    # Optimització amb Scour
    options = scour.sanitizeOptions()
    options.remove_metadata = True
    options.shorten_ids = True
    options.strip_comments = True
    options.enable_viewboxing = True
    options.indent_type = None
    options.float_precision = 0  # decimals mínims

    optimized_svg = scour.scourString(raw_svg, options)
    # Elimina declaració XML inicial si existeix
    optimized_svg = optimized_svg.replace('<?xml version="1.0" encoding="UTF-8"?>', '').strip()

    with open(output_file, "w") as f:
        f.write(optimized_svg)

    print(f"SVG centrat, flipat i ultralleuger guardat a {output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <codepoint_hex> <output_file>")
        sys.exit(1)
    extract_glyph_svg(sys.argv[1], sys.argv[2])
