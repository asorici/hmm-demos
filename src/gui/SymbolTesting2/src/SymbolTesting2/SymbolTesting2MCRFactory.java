/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Wed Sep 12 20:51:19 2012
 * Arguments: "-B" "macro_default" "-W" "java:SymbolTesting2,CallbackInterface" "-T" 
 * "link:lib" "-d" 
 * "/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/gui/SymbolTesting2/src" 
 * "-w" "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{CallbackInterface:/home/alex/Desktop/AI-MAS/ARIA/education/workshops/w1/hmm-gesture-recognition/hmm-demos/src/matlab/gestureapp/gui_interfacing/gui_interfacing.m}" 
 */

package SymbolTesting2;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class SymbolTesting2MCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "SymbolTestin_AAA9FD9AF9C378AEE00A60F222D04084";
    
    /** Component name */
    private static final String sComponentName = "SymbolTesting2";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(SymbolTesting2MCRFactory.class)
        );
    
    
    private SymbolTesting2MCRFactory()
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
            SymbolTesting2MCRFactory.class, 
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
