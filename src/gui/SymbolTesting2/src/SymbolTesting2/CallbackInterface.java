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

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;
import java.util.*;

/**
 * The <code>CallbackInterface</code> class provides a Java interface to the M-functions
 * from the files:
 * <pre>
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/gui_interfacing.m
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/test_fun.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>CallbackInterface</code> 
 * instance when it is no longer needed to ensure that native resources allocated by this 
 * class are properly freed.
 * @version 0.0
 */
public class CallbackInterface extends MWComponentInstance<CallbackInterface>
{
    /**
     * Tracks all instances of this class to ensure their dispose method is
     * called on shutdown.
     */
    private static final Set<Disposable> sInstances = new HashSet<Disposable>();

    /**
     * Maintains information used in calling the <code>gui_interfacing</code> M-function.
     */
    private static final MWFunctionSignature sGui_interfacingSignature =
        new MWFunctionSignature(/* max outputs = */ 1,
                                /* has varargout = */ false,
                                /* function name = */ "gui_interfacing",
                                /* max inputs = */ 3,
                                /* has varargin = */ true);
    /**
     * Maintains information used in calling the <code>test_fun</code> M-function.
     */
    private static final MWFunctionSignature sTest_funSignature =
        new MWFunctionSignature(/* max outputs = */ 1,
                                /* has varargout = */ false,
                                /* function name = */ "test_fun",
                                /* max inputs = */ 1,
                                /* has varargin = */ false);

    /**
     * Shared initialization implementation - private
     */
    private CallbackInterface (final MWMCR mcr) throws MWException
    {
        super(mcr);
        // add this to sInstances
        synchronized(CallbackInterface.class) {
            sInstances.add(this);
        }
    }

    /**
     * Constructs a new instance of the <code>CallbackInterface</code> class.
     */
    public CallbackInterface() throws MWException
    {
        this(SymbolTesting2MCRFactory.newInstance());
    }
    
    private static MWComponentOptions getPathToComponentOptions(String path)
    {
        MWComponentOptions options = new MWComponentOptions(new MWCtfExtractLocation(path),
                                                            new MWCtfDirectorySource(path));
        return options;
    }
    
    /**
     * @deprecated Please use the constructor {@link #CallbackInterface(MWComponentOptions componentOptions)}.
     * The <code>com.mathworks.toolbox.javabuilder.MWComponentOptions</code> class provides API to set the
     * path to the component.
     * @param pathToComponent Path to component directory.
     */
    public CallbackInterface(String pathToComponent) throws MWException
    {
        this(SymbolTesting2MCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    }
    
    /**
     * Constructs a new instance of the <code>CallbackInterface</code> class. Use this 
     * constructor to specify the options required to instantiate this component.  The 
     * options will be specific to the instance of this component being created.
     * @param componentOptions Options specific to the component.
     */
    public CallbackInterface(MWComponentOptions componentOptions) throws MWException
    {
        this(SymbolTesting2MCRFactory.newInstance(componentOptions));
    }
    
    /** Frees native resources associated with this object */
    public void dispose()
    {
        try {
            super.dispose();
        } finally {
            synchronized(CallbackInterface.class) {
                sInstances.remove(this);
            }
        }
    }
  
    /**
     * Invokes the first m-function specified by MCC, with any arguments given on
     * the command line, and prints the result.
     */
    public static void main (String[] args)
    {
        try {
            MWMCR mcr = SymbolTesting2MCRFactory.newInstance();
            mcr.runMain( sGui_interfacingSignature, args);
            mcr.dispose();
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
    
    /**
     * Calls dispose method for each outstanding instance of this class.
     */
    public static void disposeAllInstances()
    {
        synchronized(CallbackInterface.class) {
            for (Disposable i : sInstances) i.dispose();
            sInstances.clear();
        }
    }

    /**
     * Provides the interface for calling the <code>gui_interfacing</code> M-function 
     * where the first input, an instance of List, receives the output of the M-function and
     * the second input, also an instance of List, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
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
     * </p>
     * @param lhs List in which to return outputs. Number of outputs (nargout) is
     * determined by allocated size of this List. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs List containing inputs. Number of inputs (nargin) is determined
     * by the allocated size of this List. Input arguments may be passed as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or
     * as arrays of any supported Java type. Arguments passed as Java types are
     * converted to MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void gui_interfacing(List lhs, List rhs) throws MWException
    {
        fMCR.invoke(lhs, rhs, sGui_interfacingSignature);
    }

    /**
     * Provides the interface for calling the <code>gui_interfacing</code> M-function 
     * where the first input, an Object array, receives the output of the M-function and
     * the second input, also an Object array, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
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
     * </p>
     * @param lhs array in which to return outputs. Number of outputs (nargout)
     * is determined by allocated size of this array. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs array containing inputs. Number of inputs (nargin) is
     * determined by the allocated size of this array. Input arguments may be
     * passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void gui_interfacing(Object[] lhs, Object[] rhs) throws MWException
    {
        fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sGui_interfacingSignature);
    }

    /**
     * Provides the standard interface for calling the <code>gui_interfacing</code>
     * M-function with 3 input arguments.
     * Input arguments may be passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     *
     * <p>M-documentation as provided by the author of the M function:
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
     * </p>
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     * @return Array of length nargout containing the function outputs. Outputs
     * are returned as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
     * should be freed by calling its <code>dispose()</code> method.
     * @throws MWException An error has occurred during the function call.
     */
    public Object[] gui_interfacing(int nargout, Object... rhs) throws MWException
    {
        Object[] lhs = new Object[nargout];
        fMCR.invoke(Arrays.asList(lhs), 
                    MWMCR.getRhsCompat(rhs, sGui_interfacingSignature), 
                    sGui_interfacingSignature);
        return lhs;
    }
    /**
     * Provides the interface for calling the <code>test_fun</code> M-function 
     * where the first input, an instance of List, receives the output of the M-function and
     * the second input, also an instance of List, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %TEST_FUN Summary of this function goes here
     * %   Detailed explanation goes here
     * </pre>
     * </p>
     * @param lhs List in which to return outputs. Number of outputs (nargout) is
     * determined by allocated size of this List. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs List containing inputs. Number of inputs (nargin) is determined
     * by the allocated size of this List. Input arguments may be passed as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or
     * as arrays of any supported Java type. Arguments passed as Java types are
     * converted to MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void test_fun(List lhs, List rhs) throws MWException
    {
        fMCR.invoke(lhs, rhs, sTest_funSignature);
    }

    /**
     * Provides the interface for calling the <code>test_fun</code> M-function 
     * where the first input, an Object array, receives the output of the M-function and
     * the second input, also an Object array, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %TEST_FUN Summary of this function goes here
     * %   Detailed explanation goes here
     * </pre>
     * </p>
     * @param lhs array in which to return outputs. Number of outputs (nargout)
     * is determined by allocated size of this array. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs array containing inputs. Number of inputs (nargin) is
     * determined by the allocated size of this array. Input arguments may be
     * passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void test_fun(Object[] lhs, Object[] rhs) throws MWException
    {
        fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sTest_funSignature);
    }

    /**
     * Provides the standard interface for calling the <code>test_fun</code>
     * M-function with 1 input argument.
     * Input arguments may be passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     *
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %TEST_FUN Summary of this function goes here
     * %   Detailed explanation goes here
     * </pre>
     * </p>
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the M function.
     * @return Array of length nargout containing the function outputs. Outputs
     * are returned as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
     * should be freed by calling its <code>dispose()</code> method.
     * @throws MWException An error has occurred during the function call.
     */
    public Object[] test_fun(int nargout, Object... rhs) throws MWException
    {
        Object[] lhs = new Object[nargout];
        fMCR.invoke(Arrays.asList(lhs), 
                    MWMCR.getRhsCompat(rhs, sTest_funSignature), 
                    sTest_funSignature);
        return lhs;
    }
}
