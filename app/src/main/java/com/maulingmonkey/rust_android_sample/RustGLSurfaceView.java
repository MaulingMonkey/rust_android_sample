package com.maulingmonkey.rust_android_sample;
import android.content.Context;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.util.AttributeSet;
import android.util.Log;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

// https://developer.android.com/reference/android/opengl/GLSurfaceView
public class RustGLSurfaceView extends GLSurfaceView {
    static {
        System.loadLibrary("rust_android_sample");
    }

    public RustGLSurfaceView (Context context, AttributeSet attributes) {
        super(context, attributes);
        setDebugFlags(DEBUG_CHECK_GL_ERROR | DEBUG_LOG_GL_CALLS);
        setEGLContextClientVersion(2);
        //setEGLConfigChooser(8 , 8, 8, 8, 16, 0);
        setRenderer(new Renderer());
        setRenderMode(RENDERMODE_CONTINUOUSLY);
    }

    // https://developer.android.com/reference/android/opengl/GLSurfaceView.Renderer.html
    public static class Renderer implements GLSurfaceView.Renderer {
        @Override public native void onSurfaceCreated (GL10 gl, EGLConfig config);
        @Override public native void onSurfaceChanged (GL10 gl, int width, int height);
        @Override public native void onDrawFrame (GL10 gl);
    }
}
