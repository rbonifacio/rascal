/*******************************************************************************
 * Copyright (c) 2009-2011 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:

 *   * Arnold Lankamp - Arnold.Lankamp@cwi.nl
*******************************************************************************/
package org.rascalmpl.parser.gtd.stack;

import org.rascalmpl.parser.gtd.result.AbstractNode;
import org.rascalmpl.parser.gtd.result.CharNode;
import org.rascalmpl.parser.gtd.result.RecoveryNode;

public final class RecoveryStackNode extends AbstractMatchableStackNode{
	private final int[] until;
	private final RecoveryNode result;
	
	public RecoveryStackNode(int id, int[] until){
		super(id, 0);
		this.until = until;
		this.result = null;
	}
	
	private RecoveryStackNode(RecoveryStackNode original, int startLocation){
		super(original, startLocation);
		this.until = original.until;
		this.result = null;
	}
	
	private RecoveryStackNode(RecoveryStackNode original, RecoveryNode result, int startLocation){
		super(original, startLocation);
		this.until = original.until;
		this.result = result;
	}
	
	@Override
	public boolean isEndNode() {
		// TODO: I hope this makes sure that a failing production will end with this node
		return true;
	}
	
	public boolean isEmptyLeafNode(){
		return false;
	}
	
	public AbstractNode match(int[] input, int location) {
		int from = location;
		int to = location;
		
		for ( ; to < input.length; to++) {
			for (int i = 0; i < until.length; i++) {
				if (input[to] == until[i]) {
					return buildResult(input, from, to);
				}
			}
		}
		
		if (to == input.length) {
			return buildResult(input, from, input.length - 1);
		}
		
		return null; // no lookahead character found to skip to, match failes
	}
	
	private RecoveryNode buildResult(int[] input, int from, int to) {
		CharNode[] chars = new CharNode[to - from + 1];
		for (int i = from, j = 0; i <= to; i++, j++) {
			chars[j] = new CharNode(input[i]);
		}
		
		return new RecoveryNode(chars, production, from);
	}

	public AbstractStackNode getCleanCopy(int startLocation){
		return new RecoveryStackNode(this, startLocation);
	}
	
	public AbstractStackNode getCleanCopyWithResult(int startLocation, AbstractNode result){
		return new RecoveryStackNode(this, (RecoveryNode) result, startLocation);
	}
	
	public int getLength(){
		return result.getLength();
	}
	
	public AbstractNode getResult(){
		return result;
	}
	
	public String toString(){
		StringBuilder sb = new StringBuilder();
		sb.append(getId());
		sb.append('(');
		sb.append(startLocation);
		sb.append(')');
		
		return sb.toString();
	}
	
	public int hashCode(){
		return production.hashCode();
	}
	
	public boolean isEqual(AbstractStackNode stackNode){
		if(!(stackNode instanceof RecoveryStackNode)) return false;
		
		RecoveryStackNode otherNode = (RecoveryStackNode) stackNode;
		
		if(!production.equals(otherNode.production)) return false;
		
		return true;
	}
}
