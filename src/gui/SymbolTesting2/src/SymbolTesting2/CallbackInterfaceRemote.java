/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Wed Sep 12 21:05:02 2012
 * Arguments: "-B" "macro_default" "-W" "java:SymbolTesting2,CallbackInterface" "-T" 
 * "link:lib" "-d" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/gui/SymbolTesting2/src" 
 * "-w" "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{CallbackInterface:/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/gui_interfacing.m,/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/test_fun.m}" 
 */

package SymbolTesting2;

import com.mathworks.toolbox.javabuilder.pooling.Poolable;
import java.util.List;
import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * The <code>CallbackInterfaceRemote</code> class provides a Java RMI-compliant interface 
 * to the M-functions from the files:
 * <pre>
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/gui_interfacing.m
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/test_fun.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a 
 * <code>CallbackInterfaceRemote</code> instance when it is no longer needed to ensure 
 * that native resources allocated by this class are properly freed, and the server-side 
 * proxy is unexported.  (Failure to call dispose may result in server-side threads not 
 * being properly shut down, which often appears as a hang.)  
 *
 * This interface is designed to be used together with 
 * <code>com.mathworks.toolbox.javabuilder.remoting.RemoteProxy</code> to automatically 
 * generate RMI server proxy objects for instances of SymbolTesting2.CallbackInterface.
 */
public interface CallbackInterfaceRemote extends Poolable
{
    /**
     * Provides the standard interface for calling the <code>gui_interfacing</code> 
     * M-function with 3 input arguments.  
     *
     * Input arguments to standard interface methods may be passed as sub-classes of 
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of any 
     * supported Java type (i.e. scalars and multidimensional arrays of any numeric, 
     * boolean, or character type, or String). Arguments passed as Java types are 
     * converted to MATLAB arrays according to default conversion rules.
     *
     * All inputs to this method must implement either Serializable (pass-by-value) or 
     * Remote (pass-by-reference) as per the RMI specification.
     *
     * M-documentation as provided by the author of the M function:
     * <pre>
     * %%GUI_INTERFACING 
     * %   provides interfacing between GUI actions and custom defined
     * %   scripts of the symbol recognition application
     * %   Inputs:
     * %       widgetName: the name of the GUI control which fired this request
     * %       event:      the type of action performed on the widget
     * %                   e.g. mouseClick, mousePressed, etc
     * %       varargin:   additional arguments specific to this request
     * %   Outputs:
     * %       output: a cell array containing arguments returned
     * %               by the specific handling of each request. The GUI
     * %               frontend making the call must know the semantics of
     * %               the returned output
     * </pre>
     *
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     *
     * @return Array of length nargout containing the function outputs. Outputs are 
     * returned as sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>. 
     * Each output array should be freed by calling its <code>dispose()</code> method.
     *
     * @throws java.jmi.RemoteException An error has occurred during the function call or 
     * in communication with the server.
     */
    public Object[] gui_interfacing(int nargout, Object... rhs) throws RemoteException;
    /**
     * Provides the standard interface for calling the <code>test_fun</code> M-function 
     * with 1 input argument.  
     *
     * Input arguments to standard interface methods may be passed as sub-classes of 
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of any 
     * supported Java type (i.e. scalars and multidimensional arrays of any numeric, 
     * boolean, or character type, or String). Arguments passed as Java types are 
     * converted to MATLAB arrays according to default conversion rules.
     *
     * All inputs to this method must implement either Serializable (pass-by-value) or 
     * Remote (pass-by-reference) as per the RMI specification.
     *
     * M-documentation as provided by the author of the M function:
     * <pre>
     * %TEST_FUN Summary of this function goes here
     * %   Detailed explanation goes here
     * </pre>
     *
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     *
     * @return Array of length nargout containing the function outputs. Outputs are 
     * returned as sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>. 
     * Each output array should be freed by calling its <code>dispose()</code> method.
     *
     * @throws java.jmi.RemoteException An error has occurred during the function call or 
     * in communication with the server.
     */
    public Object[] test_fun(int nargout, Object... rhs) throws RemoteException;
  
    /** Frees native resources associated with the remote server object */
    void dispose() throws RemoteException;
}
