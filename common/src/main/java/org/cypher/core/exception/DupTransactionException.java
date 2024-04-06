package org.tron.core.exception;

public class DupTransactionException extends CypherException {

  public DupTransactionException() {
    super();
  }

  public DupTransactionException(String message) {
    super(message);
  }
}
