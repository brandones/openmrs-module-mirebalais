/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.mirebalais;

import org.openmrs.api.context.Context;
import org.openmrs.module.paperrecord.PaperRecordConstants;

public class MirebalaisGlobalProperties {
	
	public static final String ADDRESS_LAYOUT_FORMAT() {
		return Context.getAdministrationService().getGlobalProperty("layout.address.format");
	}

    public static final String PAPER_RECORD_IDENTIFIER_TYPE() {
        return Context.getAdministrationService().getGlobalProperty(PaperRecordConstants.GP_PAPER_RECORD_IDENTIFIER_TYPE);
    }

    public static final String INSTALLED_ADDRESS_HIERARCHY_VERSION = "mirebalais.installedAddressHierarchyVersion";

}
