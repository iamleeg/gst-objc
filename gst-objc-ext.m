#import "gst-objc-ext.h"

#ifdef __APPLE__

@implementation NSWindow (gst)

- (id) initWithContentRectPointer: (NSRect*) rect styleMask: (NSUInteger) windowAtyle backing: (NSBackingStoreType) bufferingType defer: (BOOL)deferCreation
{
  return [self initWithContentRect: NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height) 
			 styleMask: windowAtyle 
			   backing: bufferingType 
			     defer: deferCreation];
}
@end

@implementation NSView (gst)
- (NSRect *) gstBounds
{
  NSRect * rect = malloc (sizeof (NSRect));
  NSRect returnRect = [self bounds];

  rect->origin.x = returnRect.origin.x;
  rect->origin.y = returnRect.origin.y;
  rect->size.width = returnRect.size.width;
  rect->size.height = returnRect.size.height;
  return rect;
}
@end

void
fillRed (id self, SEL _cmd, NSRect rect)
{
  [[NSColor redColor] set];
  NSRectFill ([self bounds]);
}

void
gst_rectFill (NSRect * rect)
{
  NSRectFill (NSMakeRect (rect->origin.x, rect->origin.y, rect->size.width, rect->size.height));
}

#endif // __APPLE__