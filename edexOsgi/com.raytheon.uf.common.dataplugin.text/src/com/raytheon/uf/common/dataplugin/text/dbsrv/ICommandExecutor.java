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
package com.raytheon.uf.common.dataplugin.text.dbsrv;

import com.raytheon.uf.common.message.Message;

/**
 * Command executor interface for textdbsrv
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 7, 2008        1538 jkorman     Initial creation
 * May 15, 2014 2536       bclement    moved from uf.edex.textdbsrv
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.0
 */

public interface ICommandExecutor {

    
    /**
     * 
     * @param cmdMessage
     * @return
     */
    public Message execute(Message cmdMessage);
    
    /**
     * 
     */
    public void dispose();

}
