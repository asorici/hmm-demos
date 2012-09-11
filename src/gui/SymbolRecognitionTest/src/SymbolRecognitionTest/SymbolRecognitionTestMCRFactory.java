/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Tue Sep 11 14:41:27 2012
 * Arguments: "-B" "macro_default" "-W" "java:SymbolRecognitionTest,SymbolTesting" "-T" 
 * "link:lib" "-d" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/gui/SymbolRecognitionTest/src" 
 * "-w" "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{SymbolTesting:/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/testing/symbol_recognize.m}" 
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

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class SymbolRecognitionTestMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "SymbolRecogn_51B7AB0627779022B1BB6640448FC003";
    
    /** Component name */
    private static final String sComponentName = "SymbolRecognitionTest";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(SymbolRecognitionTestMCRFactory.class)
        );
    
    
    private SymbolRecognitionTestMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            SymbolRecognitionTestMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{7,16,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
