#[allow(non_snake_case)]
#[cfg(target_os="android")]
mod android {
    use std::ffi::{CString, CStr};
    use jni::JNIEnv;
    use jni::objects::{JObject, JString};
    use jni::sys::{jstring};
    use std::ffi::c_void;

    #[link(name = "EGL")] extern {
        /// Cause bugs?
        ///
        /// https://twitter.com/id_aa_carmack/status/387383037794603008?lang=en
        /// "Android eglGetProcAddress() returns a valid address for ANY STRING. I wasted hours because glRenderBufferStorageMultisample had wrong case."
        ///
        /// https://www.khronos.org/registry/EGL/sdk/docs/man/html/eglGetProcAddress.xhtml
        fn eglGetProcAddress (procname: *const u8) -> *const c_void;
    }

    // See MainActivity.java
    #[no_mangle] pub extern "system" fn Java_com_maulingmonkey_rust_1android_1sample_MainActivity_stringFromJNI(env: JNIEnv, _: JObject, j_recipient: JString) -> jstring {
        let recipient = unsafe { CString::from(CStr::from_ptr(env.get_string(j_recipient).unwrap().as_ptr())) };
        let output = env.new_string(format!("Hello {}, from Rust!", recipient.to_str().unwrap())).unwrap();
        output.into_inner()
    }

    // See RustGLSurfaceView.java
    #[no_mangle] pub extern "system" fn Java_com_maulingmonkey_rust_1android_1sample_RustGLSurfaceView_00024Renderer_onSurfaceCreated(_env: JNIEnv, _this: JObject, _gl: JObject, _egl_config: JObject) {
        unsafe {
            gl::load_with(|s| eglGetProcAddress(CString::new(s).unwrap().as_ptr() as *const _));
        }
    }

    #[no_mangle] pub extern "system" fn Java_com_maulingmonkey_rust_1android_1sample_RustGLSurfaceView_00024Renderer_onSurfaceChanged(_env: JNIEnv, _this: JObject, _gl: JObject, width: i32, height: i32) {
        unsafe {
            gl::Viewport(0, 0, width, height);
        }
    }

    #[no_mangle] pub extern "system" fn Java_com_maulingmonkey_rust_1android_1sample_RustGLSurfaceView_00024Renderer_onDrawFrame(_env: JNIEnv, _this: JObject, _gl: JObject) {
        unsafe {
            gl::ClearColor(0.1, 0.2, 0.3, 1.0);
            gl::Clear(gl::COLOR_BUFFER_BIT);
        }
    }
}
