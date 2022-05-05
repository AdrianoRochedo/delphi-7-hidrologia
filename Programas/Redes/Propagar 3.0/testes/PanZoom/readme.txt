
Readme file for TPanZoomPanel

Files included in this archive:

PanZoom.pas - Unit containing TPanZoomPanel and supporting classes.
ProportionalScrollBar.pas - Unit containing a scroll bar with a PageSize
                            property. This property was added to the standard
                            TScrollBar in Delphi4, so it's not needed there.
Project1.dpr - Project file for the example app.
Unit1.pas - Main form for the example app.
Unit1.dfm - Resource file for the main form. (Compiled with D4, so users of
            earlier versions may get some ignorable warnings.)



***Overview:

TPanZoomPanel is a panel component that encapsulates panning, zooming,
painting, and scaling functionality. With this component, you can easily pan,
zoom, and paint on an image, and define a coordinate system. The coordinate
system will intelligently follow all zooming and panning operations,
preserving the correct scale and orientation as expected.

***Hierarchy:

TPanZoomPanel descends from TResizablePanel, which descends from TPanel.
TResizablePanel introduces some message-handling capabilities that allow a
user to resize and drag a panel on a form at run-time.

***Terminology:

"Device" coordinates refer to the pixel coordinates of the panel. (0, 0) is
the upper-left-hand coordinate, as per the Windows convention. "Actual"
coordinates refer the the real-world coordinates that the device coordinates
represent. The mapping between device coordaintes and actual coordinates is
the "scaling" of the image.

The PanZoom unit defines two types for dealing with device and actual
coordinates. These types are both records, called TLongintPoint and
TDoublePoint, respectively. Each of these types has two fields, X, and Y,
which are Longints or Doubles, respectively. Functions are defined for quickly
creating the types, namely MakeLongintPoint and MakeDoublePoint. These types
and functions are analogous to Delphi's TPoint record and Point function.

***How it all works:

The idea behind using the TPanZoomPanel component is simple: Give it a bitmap,
define a coordinate system, and everything else is taken care of. Setting up a
bitmap is simple: Set the Bitmap property at run-time. (A design-time Bitmap
property would be nice, but I haven't gotten it to cooperate yet.)

Defining a coordinate system is also fairly easy. You have two options: use a
skew point or not. The skew point is for coordinate systems that are rotated
from the screen's horizontal. By specifying a skew point whose Y coordinate is
the same as the first scale point, you can deskew the coordinate system,
correcting for any rotation. Since most images aren't perfectly square, this
is often-times a good choice. If the image is square (or close enough), you
can ignore the skew point, and just give two points for defining a mapping.

Two points are required to define a scale system. We will call them
FirstScalePoint and SecondScalePoint. You set them by calling the procedures
SetFirstScalePoint and SetSecondScalePoint, respectively. These procedures
take a TLongintPoint and a TDoublePoint. The TLongintPoint is the device
coordinate: the specification in pixels of where the point is on the screen.
The TDoublePoint is the actual point: the real-world coordinates that the
device point represents.

If you need to define a skew point, call SetSkewPoint. This procedure takes a
TLongintPoint, which is the device coordinates of the skew point.

While setting these points, the published property ShowScalePoints determines
whether or not they are painted on the image to give a visual feedback.

While many of these features seem odd (e.g., why not just define the scale in
one procedure call?), they are designed so that the end-user can define the
scale by simply pointing and clicking (perhaps on some register marks).

When you have set the points, you can define the scale system by calling
DefineScale or DefineScaleNoSkew, depending on whether you're using a skew
point. These procedures take two Booleans, XIslogarithmic, and YIsLogarithmic,
which tell the panel if either or both axes are logarithmic (useful for
scientific plots, not so useful for maps).

Now the scale is defined. If you need to convert a given device coordinate to
its actual value, or vice vers‘, use the DeviceToActual and ActualToDevice
procedures. The OnMouseDown, OnMouseUp, and OnMouseMove events all give the
device coordinates and actual coordinates for the event.


***Features:

TPanZoomPanel is rich in features, many of which need explanation. They are
given below:

**Public properties:

Bitmap (read/write): This is the TBitmap image that you are working with.
Writing to this property calls TBitmap.Assign, thus copying the source bitmap.

PaintBoxCanvas (read-only): TPanZoomPanel uses a TPaintBox to do its
rendering. Use this property to get direct access to the PaintBox's canvas.

Painting (read/write): Gives the current state of whether the panel is
painting. Set this to true to begin painting. All MouseMove events will paint
on the canvas until Painting is set to False. While painting, the mouse cursor
represents a square reflecting the size of the current pen. Painting is not allowed while ZoomingIn.

PenWidth (read/write): Gets/sets the current size of the painting pen.

FirstScalePointDevice, FirstScalePointActual, SecondScalePointDevice,
SecondScalePointActual (read-only): These are the coordinates representing the
scale points. Two scale points are required to define a scale. These
properties are read-only; to set them, use the SetFirstScalePoint and
SetSecondScalePoint procedures.

ScaleDefined (read-only): Tells whether a scale has been set for the image.

SkewPointDevice (read-only): Only two scale points are needed if the image is
perfectly "square" with the screen. If it is skewed, you can either rotate it
(using another graphics tool) or give a skew coordinate. This is the device
coordinate of another point on the same X-axis as the first scale point. This
property is read-only; to set it, use the SetSkewPoint procedure.

ZoomingIn (read/write): Gets/sets the current zooming-in state. If true, then
the panel is waiting for the user to click and drag a box defining the zoom
area. Set this to true to begin this mode. Set this to false to cancel the
mode without zooming.

**Public functions:

ActualToDevice, DeviceToActual: Converts from actual coordinates to device
coordinates, and vice versa.

**Public procedures:

ClearScalePoints: Undefines all thte scale points.

ZoomOut: Takes a factor as a double and zooms out by this much.

OneToOne: Returns the zoom to its original state, i.e. a 1:1 ratio.

SizeToImage: Sizes the panel to fit the image, so that scroll bars aren't
necessary.

LoadFromStream, SaveToStream: Methods for loading and saving the panel's zoom
and scale state from/to a TStream.

DefineScale, DefineScaleNoSkew: Methods for defining the scale once the
appropriate scale points have been set.

UndefineScale: Undefines the scale.

ClearBitmap: Clears the bitmap.

SetFirstScalePoint, UnsetFirstScalePoint: Sets/unsets the first scale point.
(see above, under "How it all works".)

SetSecondScalePoint, UnsetSecondScalePoint: Sets/unsets the second scale point.

SetSkewPoint, UnsetSkewPoint: Sets/unsets the skew point.

**Published properties:

LargeChange (read/write): Gets/sets the LargeChange property of the scroll
bars.

PaintBoxCursor (read/write): Gets/sets the cursor used while over the image.
Defaults to a crosshair.

ProportionalZoom (read/write): Set this to True to use a proportional zoom.
When this is True and you zoom in, the image will be stretched to fit the
current panel dimensions, minimizing distortion. The rubberband will reflect
this constraint.

RubberBandWidth (read/write): Specifies the width of the rubberband box when
you're dragging for a zoom in.

ShowScalePoints (read/write): Set this to True to paint the scale points as
they are being defined. Once the scale is defined, they go away.

SmallChange (read/write): Gets/sets the SmallChange property of the scroll
bars.

UseFastPainting: (read/write): Set this to true to allow for more efficient
painting. In Delphi 2, once a TBitmap's Handle was accessed, the bitmap was
converted to the pixel depth of the screen. This made for faster blits, and
thus more efficient painting. Setting this to true will grab the bitmap's
handle immediately, trading speed for memory consumption. In D3 and D4, this
sets the bitmap's PixelFormat to pfDevice. However, this doesn't seem to help,
so I'm still working on how to speed up painting in D3 and D4.

UseSpanningCursor: (read/write): Set this to true to get a crosshair cursor
that spans the entire image. This is useful for lining the cursor up with a
hash mark that might be on the other side of the image. Currently this feature
enjoys some interesting color problems, and it occasionally misses a repaint.
It's not perfect. I'm working on it.

ZoomCursor: (read/write): The cursor to use while dragging to zoom in.
Defaults to a crosshair.

**Published events:

OnMouseDown, OnMouseUp, OnMouseMove: Similar to a standard TPanel's mouse
events, but they provide the corresponding actual coordinates of the event.

OnMouseEnter, OnMouseLeave: These events are fired when the cursor enters or
leaves the client area. Always a nice thing to have. Should be standard with
the TPanel, but it's not, so I added it.

OnPaintBegin, OnPaintEnd: Called when you start or stop painting.

OnPaintBoxPaint: Called when the PaintBox processes its WM_PAINT message.

OnScaleDefined, OnScaleUndefined: Called when the scale is defined/undefined.

OnZoomInBegin, OnZoomInCancel, OnZoomInEnd: Called when the user begins the
drag-and-zoom mode, when the user cancels drag-and-zoom mode, or when
drag-and-zoom mode is completed, respectively.

OnZoomOut: Called when the user zooms the image out.


***The example project:

The example project features a TPanZoomPanel, and some buttons, checkboxes,
and text boxes for manipulating its properties.

Before running the project, you should install the TPanZoomPanel component via
the usual method of installation. (e.g. Component|Install Component...)

Begin the demo by loading an image. Click the Load Image button, and choose a
BMP file. When an image is loaded, the demo project defines the
lower-left-hand corner to be (0,0) and the upper-right-hand corner to be
(100,100). This is reflected in the status bar just below the image.

Now you can play with the other features, like panning, zooming and painting.
Examine the source under each button's event. The code is straightforward and
simple, which is of course the idea behind a component.

This component was written for my needs, so some of behavior may seem limited
or inflexible. Of course, making the component more general is always a good
idea, and I welcome comments.

Enjoy,

Dave Shapiro
daves@cfxc.com

