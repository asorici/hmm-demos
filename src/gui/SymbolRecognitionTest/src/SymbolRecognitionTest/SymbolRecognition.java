/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Tue Sep 11 14:34:59 2012
 * Arguments: "-B" "macro_default" "-W" "java:SymbolRecognitionTest,SymbolRecognition" 
 * "-T" "link:lib" "-d" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/gui/SymbolRecognitionTest/src" 
 * "-w" "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{SymbolRecognition:/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/symbol_recognize.m}" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/circle_hmm_bakis.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/circle_hmm_ergodic.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/acquisition/feature_extraction_parameters.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/infinity_hmm_bakis.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/infinity_hmm_ergodic.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/left_arrow_hmm_bakis.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/left_arrow_hmm_ergodic.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/right_arrow_hmm_bakis.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/right_arrow_hmm_ergodic.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/square_hmm_bakis.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/square_hmm_ergodic.mat" 
 * "-a" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/acquisition/symbol_feature_codebook.mat" 
 */

package SymbolRecognitionTest;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;
import java.util.*;

/**
 * The <code>SymbolRecognition</code> class provides a Java interface to the M-functions
 * from the files:
 * <pre>
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/symbol_recognize.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>SymbolRecognition</code> 
 * instance when it is no longer needed to ensure that native resources allocated by this 
 * class are properly freed.
 * @version 0.0
 */
public class SymbolRecognition extends MWComponentInstance<SymbolRecognition>
{
    /**
     * Tracks all instances of this class to ensure their dispose method is
     * called on shutdown.
     */
    private static final Set<Disposable> sInstances = new HashSet<Disposable>();

    /**
     * Maintains information used in calling the <code>symbol_recognize</code> M-function.
     */
    private static final MWFunctionSignature sSymbol_recognizeSignature =
        new MWFunctionSignature(/* max outputs = */ 2,
                                /* has varargout = */ false,
                                /* function name = */ "symbol_recognize",
                                /* max inputs = */ 2,
                                /* has varargin = */ false);

    /**
     * Shared initialization implementation - private
     */
    private SymbolRecognition (final MWMCR mcr) throws MWException
    {
        super(mcr);
        // add this to sInstances
        synchronized(SymbolRecognition.class) {
            sInstances.add(this);
        }
    }

    /**
     * Constructs a new instance of the <code>SymbolRecognition</code> class.
     */
    public SymbolRecognition() throws MWException
    {
        this(SymbolRecognitionTestMCRFactory.newInstance());
    }
    
    private static MWComponentOptions getPathToComponentOptions(String path)
    {
        MWComponentOptions options = new MWComponentOptions(new MWCtfExtractLocation(path),
                                                            new MWCtfDirectorySource(path));
        return options;
    }
    
    /**
     * @deprecated Please use the constructor {@link #SymbolRecognition(MWComponentOptions componentOptions)}.
     * The <code>com.mathworks.toolbox.javabuilder.MWComponentOptions</code> class provides API to set the
     * path to the component.
     * @param pathToComponent Path to component directory.
     */
    public SymbolRecognition(String pathToComponent) throws MWException
    {
        this(SymbolRecognitionTestMCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    }
    
    /**
     * Constructs a new instance of the <code>SymbolRecognition</code> class. Use this 
     * constructor to specify the options required to instantiate this component.  The 
     * options will be specific to the instance of this component being created.
     * @param componentOptions Options specific to the component.
     */
    public SymbolRecognition(MWComponentOptions componentOptions) throws MWException
    {
        this(SymbolRecognitionTestMCRFactory.newInstance(componentOptions));
    }
    
    /** Frees native resources associated with this object */
    public void dispose()
    {
        try {
            super.dispose();
        } finally {
            synchronized(SymbolRecognition.class) {
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
            MWMCR mcr = SymbolRecognitionTestMCRFactory.newInstance();
            mcr.runMain( sSymbol_recognizeSignature, args);
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
        synchronized(SymbolRecognition.class) {
            for (Disposable i : sInstances) i.dispose();
            sInstances.clear();
        }
    }

    /**
     * Provides the interface for calling the <code>symbol_recognize</code> M-function 
     * where the first input, an instance of List, receives the output of the M-function and
     * the second input, also an instance of List, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %%SYMBOL_RECOGNIZE test the given input track for being one of the
     * %   known symbols
     * %   Inputs
     * %       track_data:         a sequence of mouse positions together 
     * %                           with their time annotation
     * %       transition_model:   the type of transition model used for
     * %                           recognition. Choices: {bakis, ergodic}
     * %
     * %   Outputs
     * %       recognized_symbol:  the name of the recognized symbol or 
     * %                           'unknown' if no symbol could be detected
     * %       ll_vector:          the log likelihood values given by the
     * %                           trained HMM models for each symbol
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
    public void symbol_recognize(List lhs, List rhs) throws MWException
    {
        fMCR.invoke(lhs, rhs, sSymbol_recognizeSignature);
    }

    /**
     * Provides the interface for calling the <code>symbol_recognize</code> M-function 
     * where the first input, an Object array, receives the output of the M-function and
     * the second input, also an Object array, provides the input to the M-function.
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %%SYMBOL_RECOGNIZE test the given input track for being one of the
     * %   known symbols
     * %   Inputs
     * %       track_data:         a sequence of mouse positions together 
     * %                           with their time annotation
     * %       transition_model:   the type of transition model used for
     * %                           recognition. Choices: {bakis, ergodic}
     * %
     * %   Outputs
     * %       recognized_symbol:  the name of the recognized symbol or 
     * %                           'unknown' if no symbol could be detected
     * %       ll_vector:          the log likelihood values given by the
     * %                           trained HMM models for each symbol
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
    public void symbol_recognize(Object[] lhs, Object[] rhs) throws MWException
    {
        fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sSymbol_recognizeSignature);
    }

    /**
     * Provides the standard interface for calling the <code>symbol_recognize</code>
     * M-function with 2 input arguments.
     * Input arguments may be passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     *
     * <p>M-documentation as provided by the author of the M function:
     * <pre>
     * %%SYMBOL_RECOGNIZE test the given input track for being one of the
     * %   known symbols
     * %   Inputs
     * %       track_data:         a sequence of mouse positions together 
     * %                           with their time annotation
     * %       transition_model:   the type of transition model used for
     * %                           recognition. Choices: {bakis, ergodic}
     * %
     * %   Outputs
     * %       recognized_symbol:  the name of the recognized symbol or 
     * %                           'unknown' if no symbol could be detected
     * %       ll_vector:          the log likelihood values given by the
     * %                           trained HMM models for each symbol
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
    public Object[] symbol_recognize(int nargout, Object... rhs) throws MWException
    {
        Object[] lhs = new Object[nargout];
        fMCR.invoke(Arrays.asList(lhs), 
                    MWMCR.getRhsCompat(rhs, sSymbol_recognizeSignature), 
                    sSymbol_recognizeSignature);
        return lhs;
    }
}
