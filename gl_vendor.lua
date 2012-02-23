ffi.cdef[[
void glTextureRangeAPPLE(GLenum target, GLsizei length, const GLvoid *pointer);
void glGetTexParameterPointervAPPLE(GLenum target, GLenum pname, GLvoid **params);
void glVertexArrayRangeAPPLE(GLsizei length, const GLvoid *pointer);
void glFlushVertexArrayRangeAPPLE(GLsizei length, const GLvoid *pointer);
void glVertexArrayParameteriAPPLE(GLenum pname, GLint param);
void glBindVertexArrayAPPLE(GLuint id);
void glDeleteVertexArraysAPPLE(GLsizei n, const GLuint *ids);
void glGenVertexArraysAPPLE(GLsizei n, GLuint *ids);
GLboolean glIsVertexArrayAPPLE(GLuint id);
void glGenFencesAPPLE(GLsizei n, GLuint *fences);
void glDeleteFencesAPPLE(GLsizei n, const GLuint *fences);
void glSetFenceAPPLE(GLuint fence);
GLboolean glIsFenceAPPLE(GLuint fence);
GLboolean glTestFenceAPPLE(GLuint fence);
void glFinishFenceAPPLE(GLuint fence);
GLboolean glTestObjectAPPLE(GLenum object, GLuint name);
void glFinishObjectAPPLE(GLenum object, GLuint name);
void glElementPointerAPPLE(GLenum type, const GLvoid *pointer);
void glDrawElementArrayAPPLE(GLenum mode, GLint first, GLsizei count);
void glDrawRangeElementArrayAPPLE(GLenum mode, GLuint start, GLuint end, GLint first, GLsizei count);
void glMultiDrawElementArrayAPPLE(GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount);
void glMultiDrawRangeElementArrayAPPLE(GLenum mode, GLuint start, GLuint end, const GLint *first, const GLsizei *count, GLsizei primcount);
void glFlushRenderAPPLE(void);
void glFinishRenderAPPLE(void);
void glSwapAPPLE(void);
void glEnableVertexAttribAPPLE(GLuint index, GLenum pname);
void glDisableVertexAttribAPPLE(GLuint index, GLenum pname);
GLboolean glIsVertexAttribEnabledAPPLE(GLuint index, GLenum pname);
void glMapVertexAttrib1dAPPLE(GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
void glMapVertexAttrib1fAPPLE(GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
void glMapVertexAttrib2dAPPLE(GLuint index, GLuint size, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
void glMapVertexAttrib2fAPPLE(GLuint index, GLuint size, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
void glBufferParameteriAPPLE(GLenum target, GLenum pname, GLint param);
void glFlushMappedBufferRangeAPPLE(GLenum target, GLintptr offset, GLsizeiptr size);
GLenum glObjectPurgeableAPPLE(GLenum objectType, GLuint name, GLenum option);
GLenum glObjectUnpurgeableAPPLE(GLenum objectType, GLuint name, GLenum option);
void glGetObjectParameterivAPPLE(GLenum objectType, GLuint name, GLenum pname, GLint* params);
]]

ffi.cdef[[
void glPNTrianglesiATI(GLenum pname, GLint param);
void glPNTrianglesfATI(GLenum pname, GLfloat param);
void glBlendEquationSeparateATI(GLenum equationRGB, GLenum equationAlpha);
void glStencilOpSeparateATI(GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass);
void glStencilFuncSeparateATI(GLenum frontfunc, GLenum backfunc, GLint ref, GLuint mask);
]]

ffi.cdef[[
void glPNTrianglesiATIX(GLenum pname, GLint param);
void glPNTrianglesfATIX(GLenum pname, GLfloat param);
]]

ffi.cdef[[
void glPointParameteriNV(GLenum pname, GLint param);
void glPointParameterivNV(GLenum pname, const GLint *params);
void glBeginConditionalRenderNV (GLuint id, GLenum mode);
void glEndConditionalRenderNV (void);
]]
