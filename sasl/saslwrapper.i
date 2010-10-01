/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

%module saslwrapper


/* unsigned32 Convert from Python --> C */
%typemap(in) uint32_t {
    if (PyInt_Check($input)) {
        $1 = (uint32_t) PyInt_AsUnsignedLongMask($input);
    } else if (PyLong_Check($input)) {
        $1 = (uint32_t) PyLong_AsUnsignedLong($input);
    } else {
        SWIG_exception_fail(SWIG_ValueError, "unknown integer type");
    }
}

/* unsigned32 Convert from C --> Python */
%typemap(out) uint32_t {
    $result = PyInt_FromLong((long)$1);
}


/* unsigned16 Convert from Python --> C */
%typemap(in) uint16_t {
    if (PyInt_Check($input)) {
        $1 = (uint16_t) PyInt_AsUnsignedLongMask($input);
    } else if (PyLong_Check($input)) {
        $1 = (uint16_t) PyLong_AsUnsignedLong($input);
    } else {
        SWIG_exception_fail(SWIG_ValueError, "unknown integer type");
    }
}

/* unsigned16 Convert from C --> Python */
%typemap(out) uint16_t {
    $result = PyInt_FromLong((long)$1);
}


/* signed32 Convert from Python --> C */
%typemap(in) int32_t {
    if (PyInt_Check($input)) {
        $1 = (int32_t) PyInt_AsLong($input);
    } else if (PyLong_Check($input)) {
        $1 = (int32_t) PyLong_AsLong($input);
    } else {
        SWIG_exception_fail(SWIG_ValueError, "unknown integer type");
    }
}

/* signed32 Convert from C --> Python */
%typemap(out) int32_t {
    $result = PyInt_FromLong((long)$1);
}


/* unsigned64 Convert from Python --> C */
%typemap(in) uint64_t {
%#ifdef HAVE_LONG_LONG
    if (PyLong_Check($input)) {
        $1 = (uint64_t)PyLong_AsUnsignedLongLong($input);
    } else if (PyInt_Check($input)) {
        $1 = (uint64_t)PyInt_AsUnsignedLongLongMask($input);
    } else
%#endif
    {
        SWIG_exception_fail(SWIG_ValueError, "unsupported integer size - uint64_t input too large");
    }
}

/* unsigned64 Convert from C --> Python */
%typemap(out) uint64_t {
%#ifdef HAVE_LONG_LONG
    $result = PyLong_FromUnsignedLongLong((unsigned PY_LONG_LONG)$1);
%#else
    SWIG_exception_fail(SWIG_ValueError, "unsupported integer size - uint64_t output too large");
%#endif
}

/* signed64 Convert from Python --> C */
%typemap(in) int64_t {
%#ifdef HAVE_LONG_LONG
    if (PyLong_Check($input)) {
        $1 = (int64_t)PyLong_AsLongLong($input);
    } else if (PyInt_Check($input)) {
        $1 = (int64_t)PyInt_AsLong($input);
    } else
%#endif
    {
        SWIG_exception_fail(SWIG_ValueError, "unsupported integer size - int64_t input too large");
    }
}

/* signed64 Convert from C --> Python */
%typemap(out) int64_t {
%#ifdef HAVE_LONG_LONG
    $result = PyLong_FromLongLong((PY_LONG_LONG)$1);
%#else
    SWIG_exception_fail(SWIG_ValueError, "unsupported integer size - int64_t output too large");
%#endif
}


/* Convert from Python --> C */
%typemap(in) void * {
    $1 = (void *)$input;
}

/* Convert from C --> Python */
%typemap(out) void * {
    $result = (PyObject *) $1;
    Py_INCREF($result);
}

%typemap (typecheck, precedence=SWIG_TYPECHECK_UINT64) uint64_t {
    $1 = PyLong_Check($input) ? 1 : 0;
}

%typemap (typecheck, precedence=SWIG_TYPECHECK_UINT32) uint32_t {
    $1 = PyInt_Check($input) ? 1 : 0;
}

/* Handle output arguments of type "output_string" */
%typemap(in, numinputs=0) saslwrapper::output_string& (std::string temp) {
   $1 = &temp;
}

%typemap(argout) saslwrapper::output_string& {
    PyObject *o = PyString_FromStringAndSize($1->c_str(), $1->length());
    $result = append_result_tuple($result, o);
}

%typemap(in, numinputs=0) saslwrapper::output_int *(int temp) {
    temp = 0;
    $1 = &temp;
}

%typemap(argout) saslwrapper::output_int *{
    // Append output value $1 to $result
    $result = append_result_tuple($result, PyInt_FromLong( (long)*$1 ));
}

%{
#include "saslwrapper.h"
%}

%include stl.i
%include <saslwrapper.h>

%inline {

using namespace std;
using namespace saslwrapper;

namespace saslwrapper {

}

static PyObject *append_result_tuple(PyObject *result, PyObject *to_append) {
    if ((!result) || (result == Py_None)) {
        return to_append;
    } else {
        // if not istuple(result):
        //   result = (result, )
        if (!PyTuple_Check(result)) {
            PyObject *orig_result = result;
            result = PyTuple_New(1);
            PyTuple_SetItem(result, 0, orig_result);
        }
        
        // tuple_to_append = (to_append, )
        PyObject *tuple_to_append = PyTuple_New(1);
        PyTuple_SetItem(tuple_to_append, 0, to_append);

        PyObject *new_result = PySequence_Concat(result, tuple_to_append);
        Py_DECREF(result);
        Py_DECREF(tuple_to_append);
        return new_result;
    }
}

}



%{

%};

