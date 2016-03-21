
import CoreImage

public struct Pixel {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    init(red: UInt8, green: UInt8, blue: UInt8) {
        r = red
        g = green
        b = blue
        a = 255
    }
}

public func makePixelSet(width: Int, _ height: Int) -> ([Pixel], Int, Int) {
    var pixel = Pixel(red: 0, green: 0, blue: 0)
    var pixels = [Pixel](count: width * height, repeatedValue: pixel)
    let lower_left_corner = vec3(x: -2.0, y: 1.0, z: -1.0)
    let horizontal = vec3(x: 4.0, y: 0, z: 0)
    let vertical = vec3(x: 0, y: -2.0, z: 0)
    let origin = vec3()
    for i in 0..<width {
        for j in 0..<height {
            let u = Double(i) / Double(width)
            let v = Double(j) / Double(height)
            let r = ray(origin: origin, direction: lower_left_corner + u * horizontal + v * vertical)
            let col = color(r)
            pixel = Pixel(red: UInt8(col.x * 255), green: UInt8(col.y * 255), blue: UInt8(col.z * 255))
            pixels[i + j * width] = pixel
        }
    }
    return (pixels, width, height)
}

public func imageFromPixels(pixels: ([Pixel], width: Int, height: Int)) -> CIImage {
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue) // alpha is last
    let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: pixels.0, length: pixels.0.count * sizeof(Pixel)))
    let image = CGImageCreate(pixels.1, pixels.2, bitsPerComponent, bitsPerPixel, pixels.1 * sizeof(Pixel), rgbColorSpace, bitmapInfo, providerRef, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
    return CIImage(CGImage: image!)
}
