/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.viz.core.gl;

import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jface.preference.IPersistentPreferenceStore;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.raytheon.uf.common.localization.exception.LocalizationException;
import com.raytheon.uf.common.status.IUFStatusHandler;
import com.raytheon.uf.common.status.UFStatus;
import com.raytheon.uf.common.status.UFStatus.Priority;
import com.raytheon.uf.viz.core.localization.HierarchicalPreferenceStore;

/**
 * The activator class controls the plug-in life cycle
 */
public class Activator extends AbstractUIPlugin {
    private static final transient IUFStatusHandler statusHandler = UFStatus
            .getHandler(Activator.class);

    // The plug-in ID
    public static final String PLUGIN_ID = "com.raytheon.viz.core.gl";

    // The shared instance
    private static Activator plugin;

    // The preference store
    private IPersistentPreferenceStore prefs;

    /**
     * The constructor
     */
    public Activator() {
        plugin = this;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.eclipse.ui.plugin.AbstractUIPlugin#start(org.osgi.framework.BundleContext
     * )
     */
    public void start(BundleContext context) throws Exception {
        super.start(context);
        // Start the texture loader job
        TextureLoaderJob textureLoader = TextureLoaderJob.getInstance();
        if (textureLoader.getState() != Job.RUNNING) {
            textureLoader.setSystem(true);
            textureLoader.schedule();
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.eclipse.ui.plugin.AbstractUIPlugin#stop(org.osgi.framework.BundleContext
     * )
     */
    public void stop(BundleContext context) throws Exception {
        plugin = null;
        super.stop(context);
        // Start the texture loader job
        TextureLoaderJob textureLoader = TextureLoaderJob.getInstance();
        if (textureLoader.getState() == Job.RUNNING) {
            textureLoader.shutdown();
        }
    }

    /**
     * Returns the shared instance
     * 
     * @return the shared instance
     */
    public static Activator getDefault() {
        return plugin;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.ui.plugin.AbstractUIPlugin#getPreferenceStore()
     */
    @Override
    public IPersistentPreferenceStore getPreferenceStore() {
        try {
            if (prefs == null) {
                prefs = new HierarchicalPreferenceStore(this);
            }
        } catch (LocalizationException e) {
            statusHandler.handle(
                    Priority.PROBLEM,
                    "Error reading preference store: "
                            + e.getLocalizedMessage(), e);
        }

        return prefs;
    }

}
