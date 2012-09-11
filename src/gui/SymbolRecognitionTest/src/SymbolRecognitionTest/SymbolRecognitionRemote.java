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

import com.mathworks.toolbox.javabuilder.pooling.Poolable;
import java.util.List;
import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * The <code>SymbolRecognitionRemote</code> class provides a Java RMI-compliant interface 
 * to the M-functions from the files:
 * <pre>
 *  /home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/symbol_recognize.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a 
 * <code>SymbolRecognitionRemote</code> instance when it is no longer needed to ensure 
 * that native resources allocated by this class are properly freed, and the server-side 
 * proxy is unexported.  (Failure to call dispose may result in server-side threads not 
 * being properly shut down, which often appears as a hang.)  
 *
 * This interface is designed to be used together with 
 * <code>com.mathworks.toolbox.javabuilder.remoting.RemoteProxy</code> to automatically 
 * generate RMI server proxy objects for instances of 
 * SymbolRecognitionTest.SymbolRecognition.
 */
public interface SymbolRecognitionRemote extends Poolable
{
    /**
     * Provides the standard interface for calling the <code>symbol_recognize</code> 
     * M-function with 2 input arguments.  
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
    public Object[] symbol_recognize(int nargout, Object... rhs) throws RemoteException;
  
    /** Frees native resources associated with the remote server object */
    void dispose() throws RemoteException;
}
